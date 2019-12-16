//
//  ViewController.swift
//  CustomKeyboard
//
//  Created by 住田みらの on 2019/10/08.
//  Copyright © 2019 住田みらの. All rights reserved.
//
//  このプログラムはfirstViewの操作をする.

import Foundation   // SwiftCoreなどのライブラリがリンクされる
import UIKit        // UIパーツを使用するのに必要

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK:- 変数定義
    
    @IBOutlet weak var tableview: UITableView!      // firstView の部品
    @IBOutlet weak var textLabel: UILabel!          // firstView の部品
    
    //　ペリフェラルを記憶するのに使う
    let userDefaults = UserDefaults.standard

    // MARK:- override func
  
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--- viewDidLoad ---")
        bleManager?.setView(self)           // BLEManagerでViewControllerのインスタンスを作成するため
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("--- didReceiveMemoryWarning ---")
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK:- その他メソッド

    // 画面遷移：firstView -> TerminalView
    @IBAction func goTerminal(_ sender:UIButton) {
        // デバイスが選択されていなければアラートを表示
        if(bleManager?.bleDevice == nil){
            let alert: UIAlertController = UIAlertController(title: "デバイスが接続されていません", message: "Scan → デバイス選択をしてください", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "わかりました", style: UIAlertAction.Style.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
            
        }else{
           self.performSegue(withIdentifier: "toTerminal", sender: self)
        }
    }
    
    // scanButtonが押されたとき
    // sender : 押下ボタン
    @IBAction func scanTap(_ sender: UIButton) {
        print("--- scan button tapped ---")
        bleManager!.startScan()
    }
    
    
    /* tableViewに関するメソッド */
    
    //セルの個数を指定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            print("discoveredDevice Count:\(String(describing: bleManager?.bleDevices.count))")
            return (bleManager?.bleDevices.count)!
        
    }
    
    //セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell: UITableViewCell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            print("discoveredDevice Name:\(String(describing: bleManager?.bleDevices[indexPath.row].name!))")
            cell.textLabel!.text = bleManager?.bleDevices[indexPath.row].name
            return cell

    }

    func reload() {
        tableview.reloadData()      //tableviewの再表示　上記のtableView 2つが呼ばれる
    }

    // デバイスが選択されたとき
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            // ペリフェラルを登録する
            bleManager?.bleDevice = bleManager?.bleDevices[indexPath.row]
        
            //接続したTeCを可視化
            textLabel.text = "接続したTeC  :  " + (bleManager?.bleDevice.name)!
            
            // ペリフェラルを記憶する
            userDefaults.set(bleManager?.bleDevice?.name!,  forKey: "DeviceName")
            userDefaults.synchronize()
            
            // BLEデバイスの検出を終了
            bleManager?.stopScan()
            
            // 接続を開始する
            bleManager?.connect()
            
            // デバイス配列をクリアし元の画面に戻る
            bleManager?.bleDevices = []
            self.dismiss(animated: true, completion: nil)
        
    }
    
}//ViewController

