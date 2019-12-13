//
//  Ble.swift
//  CustomKeyboard
//
//  Created by 住田みらの on 2019/11/15.
//  Copyright © 2019 住田みらの. All rights reserved.
//
//  このプログラムはBLEに関する操作をする.

import Foundation       // SwiftCoreなどのライブラリがリンクされる
import UIKit            // UIパーツを使用するのに必要
import CoreBluetooth    // Bluetoothを使用するのに必要

// MLDPのサービスのUUID
let target_service_uuid = CBUUID(string:"00035B03-58E6-07DD-021A-08123A000300")                // Service
let target_charactaristic_uuid = CBUUID(string: "00035B03-58E6-07DD-021A-08123A000301")        // Read Write Notify indicate
//let target_charactaristic_uuid2 = CBUUID(string: "00035B03-58E6-07DD-021A-08123A0003FF")     // Read Write

// 文字列をターミナルから入力する
func readFromTerminal() -> String {
    return String(data: FileHandle.standardInput.availableData,
                  encoding: String.Encoding.utf8) ?? ""
}

// Dataをターミナルへ出力する
func writeDataToTerminal(_ dat:Data) {
    FileHandle.standardOutput.write(dat)
}

// 文字列をターミナルへ出力する
func writeToTerminal(_ str:String) {
    writeDataToTerminal(str.data(using: .utf8)!)
}

// メッセージをターミナルに出力する
func writeMessage(_ str:String) {
    writeToTerminal("\(str)\r\n")              // メッセージ出力
}

// BLE の状態
enum BleState {
    case powerOff                              // 初期状態
    case powerOn                               // BLE の電源が ON になっている
    case inSearch                              // デバイスを探索中
    case found                                 // 目的のデバイスが見つかった
    case trying                                // 接続作業中
    case established                           // 接続完了
    case inOperation                           // 入出力処理中
    case closed                                // 接続が終了した
}
var bleState = BleState.powerOff               // 初期状態

// BLEを管理するクラス
class BLEManager:  NSObject, CBCentralManagerDelegate{
    
    var bleManager: CBCentralManager!          // BLE のセントラルマネージャ
    var bleDevices = [CBPeripheral]()          // 発見したデバイスの一覧
    var bleDevice: CBPeripheral!               // 選択されたデバイス
    var deviceName: String?                    // 自動的に選択するデバイス名
    var outputCharacteristic:CBCharacteristic! // キャラクタリスティック
    var view: ViewController?                  // ViewControllerのインスタンス
    
    // 初期化
    override init() {
        super.init()                           // NSObjectのinit
        bleManager = CBCentralManager(         // セントラルマネージャを作る
            delegate: self as CBCentralManagerDelegate,
            queue: nil,                        // main thread のqueueを使用する
            options: nil)
    }
    
    func setView(_ V: ViewController){
        view = V
    }
    
    // セントラルマネージャの状態が変化すると呼ばれる
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            writeMessage("Bluetooth powered OFF")
            exit(1)
        case .poweredOn:
        //  writeMessage("Bluetooth powered ON")
            bleState = .powerOn
        case .resetting:
            writeMessage("Resetting")
            exit(1)
        case .unauthorized:
            writeMessage("Unauthenticated")
            exit(1)
        case .unknown:
            writeMessage("Unknown")
            exit(1)
        case .unsupported:
            writeMessage("Unsupported")
            exit(1)
        default:
            writeMessage("Unknown status")
            exit(1)
        }
    }

    // ペリフェラルを発見すると呼ばれる
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        print("\(String(describing: peripheral.name))")
        if deviceName != nil && bleDevice == nil {        // 指名ありの場合
            if deviceName == peripheral.name {
                bleDevice = peripheral
                bleState = .found                         // デバイス決定
            }
        } else if deviceName == nil {                     // 指名なしの場合
            if peripheral.name != nil && !bleDevices.contains(peripheral) {
                bleDevices.append(peripheral)
                writeMessage("\(bleDevices.count) : \(peripheral.name!)")
                view?.reload()
            }
        }
    }

    // ペリフェラルへの接続が成功すると呼ばれる
    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {
        if let name = peripheral.name {
            writeMessage("\"\(name)\"へ接続しました．")
        }
        bleState = .established                           // 接続が確立した
        activate()
        bleState = .inOperation
        view?.reload()
    }
    
    // ペリフェラルとの接続が切断されると呼ばれる
    func centralManager(_ central: CBCentralManager,
                        didDisconnectPeripheral peripheral: CBPeripheral,
                        error: Error?) {
        writeMessage("")
        writeMessage("接続が切断されました．")
        bleState = .closed                               // 接続が切断された
    }

    // BLEデバイスの検出を開始
    func startScan() {
        bleManager.scanForPeripherals(
                        withServices:[target_service_uuid], options: nil)
    }
    
    // BLEデバイスの検出を終了
    func stopScan() {
        bleManager.stopScan()
    }

    // デバイスに接続する関数
    func connect() {
        bleManager.connect(bleDevice!, options: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {  // ３秒後に
            if bleState != .inOperation {                      // 接続が完了し
                writeMessage("接続が完了しませんでした．")     //  たかチェック
                bleState = .closed
            }
        }
    }
    
    // サービス発見時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverServices error: Error?) {
        print("--- サービス発見時に呼ばれる peripheral() ---")
        
        guard error == nil else {
            print(error.debugDescription)
            return
        }
        
        guard let services = peripheral.services, services.count > 0 else {
            writeMessage("No Services")
            return
        }
        
        for service in services {          // キャラクタリスティックを探索開始
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    // キャラクタリスティック発見時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        print("--- キャラクタリスティック発見時に呼ばれる peripheral() ---")
        
        guard error == nil else {
            writeMessage(error.debugDescription)
            return
        }
        
        guard let characteristics = service.characteristics,
                                    characteristics.count > 0 else {
            writeMessage("No Characteristics")
            return
        }
        
        for characteristic in characteristics
            where characteristic.uuid.isEqual(target_charactaristic_uuid) {
            outputCharacteristic = characteristic      // 使用するもの
            peripheral.readValue(for: characteristic)
            
            // 更新通知受け取りを開始する
            peripheral.setNotifyValue(true, for: characteristic)
            
            // 接続完了をTeCに知らせる
            let str = "MLDP\r\nApp:on\r\n"
            let data = str.data(using: String.Encoding.utf8)
            peripheral.writeValue(data!, for: outputCharacteristic,
                                  type: CBCharacteristicWriteType.withResponse)
            break
        }
    }
    
    // Notify開始／停止時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral,
              didUpdateNotificationStateFor characteristic: CBCharacteristic,
              error: Error?) {
        print("--- Notify開始／停止時に呼ばれる peripheral() ---")
        
        guard error == nil else {
            writeMessage(error.debugDescription)
            return
        }
    }
    
    // データ更新時に呼ばれる
    func peripheral( _ peripheral: CBPeripheral,
              didUpdateValueFor characteristic: CBCharacteristic,
              error: Error?) {
        print("--- データ更新時に呼ばれる peripheral() ---")
        
        guard error == nil else {
            if characteristic.value != nil {           // このifは，なぜか必要
                writeMessage("\(error.debugDescription)")
            }
            return
        }
        if let data = characteristic.value {           // 受信データを取り出し
            writeDataToTerminal(data)                  // ターミナルに表示する
        }
    }
    
    // データ書き込みが完了すると呼ばれる
    func peripheral(_ peripheral: CBPeripheral,
                    didWriteValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        print("--- データ書き込みが完了すると呼ばれる peripheral() ---")
        
        if error != nil {
            writeMessage("""
               Write failed...error: \(error.debugDescription), \
               characteristic uuid: \(characteristic.uuid)
               """
            )
            bleState = .closed
        }
    }

    // サービス開始
    func activate() {
        print("--- サービス開始 activate() ---")
        bleDevice?.discoverServices([target_service_uuid])
    }

    // デバイスにデータを送信する
    func write(_ inputString : String) {
        bleDevice.writeValue(
            inputString.data(using: String.Encoding.utf8)!,
            for: outputCharacteristic,
            type: CBCharacteristicWriteType.withResponse
        )
    }

    // TeCに切断を知らせる
    func close() {
        let str = "ERR\r\nERR\r\n"
        let data = str.data(using: String.Encoding.utf8)
        bleDevice?.writeValue(data!, for: outputCharacteristic,
                              type: CBCharacteristicWriteType.withResponse)
    }
    
}//BLEManager

// ~. ~: ~? を見つけるステートマシン
var stat: Int = 0
func findEscape(_ char : Character) -> Int {
    switch stat {
    case 0:
        if char=="~" {                                 // ~ だ．
            stat = 1                                   // 用心する
            return -1                                  // 表示はちょっと待って
        }
    case 1:
        stat = 0
        if char=="." { return 2 }                      // ~. 発見
        if char==":" { return 3 }                      // ~: 発見
        if char=="?" { return 4 }                      // ~? 発見
        return 1                                       // ただの ~ だった
    default:
        stat = 0
    }
    return 0;
}

// キー入力でデバイスを選択する（キーボード用のスレッドで実行される）
func selectDevice(_ centralManager: CBCentralManager) -> CBPeripheral? {
    var number = 0                                     // 入力された数値
    while true {
        let inputString = readFromTerminal()           // 標準入力から読む
        for inputCharacter in inputString {            // 各文字について
            if findEscape(inputCharacter) == 2 {       // ~. だ
                DispatchQueue.main.async {             // mainスレッドで
                    writeMessage("")                   // ターミナル画面を改行
                }
                return nil                             // 選択されていないが
            }                                          //   終了する
            if let digit = Int(String(inputCharacter)) { // 数字なら
                writeToTerminal(String(digit))
                number = number * 10 + digit
            } else if inputCharacter == "\r" {         // [Enter]が押された
                DispatchQueue.main.async {             // mainスレッドで
                    writeMessage("")
                }
                if 0 < number && number <= (bleManager?.bleDevices.count)! {
                    return bleManager?.bleDevices[number - 1]  // 決定！！
                } else {
                    DispatchQueue.main.async {         // mainスレッドで
                        writeMessage("\"\(number)\"は選択できません．")
                    }
                    number = 0
                }
            } else if inputCharacter == "\u{7f}" {     // deleteのとき
                number = number / 10
                DispatchQueue.main.async {             // mainスレッドで
                    writeToTerminal("\u{08} \u{08}")   // 表示を一字消す
                }
            }
        }
    }
}

// キー入力を BLE に書き込む（キーボード用のスレッドで実行される）
func writeProcess(_ deviceManager: CBCentralManager) {
    while true {
        let inputString = readFromTerminal()           // 標準入力から読む
        for inputCharacter in inputString {            // 各文字について
            switch findEscape(inputCharacter) {        // エスケープをチェック
            case -1:                                   // ~ だ．
                break                                  // ちょっと待て
            case 0:                                    // 普通の文字だ．
                if bleState == .inOperation {          // 接続中なら
                  DispatchQueue.main.async {           // mainスレッドで
                    //bleManager?.write(inputCharacter)// BLEに書き込む
                  }
                }
            case 2:                                    // ~. だ．
                if bleState == .inOperation {          // 接続中なら
                   DispatchQueue.main.async {          // mainスレッドで
                    bleManager?.close()           // TeCに切断を知らせる
                   }
                }
                return
            default:                                   // 興味のない ~ だった
                if bleState == .inOperation {          // 接続中なら
                   DispatchQueue.main.async {          // mainスレッドで
                    bleManager?.write("~")        // BLEに書き込む
                   // bleManager?.write(inputCharacter)
                   }
                }
            }
        }
    }
}

