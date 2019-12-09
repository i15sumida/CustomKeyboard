//
//  AppDelegate.swift
//  CustomKeyboard
//
//  Created by 住田みらの on 2019/07/12.
//  Copyright © 2019 住田みらの. All rights reserved.
//
//  このプログラムは最初に動く

import UIKit            // UIパーツを使用するのに必要
import CoreBluetooth    // Bluetoothを使用するのに必要

var BleManager: BLEManager?     //グローバル変数　Ble.swift や ViewController でも使用可

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // アプリ起動時に呼ばれる
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("--- application ---")
        
        BleManager = BLEManager()
        return true
    }
    
    // アプリが閉じそうな時に呼ばれる
    func applicationWillResignActive(_ application: UIApplication) {
        print("--- applicationWillResignActive ---")
    }
    
    // アプリを閉じた時に呼ばれる
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("--- applicationDidEnterBackground ---")
    }

    // アプリを開きそうな時に呼ばれる
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("--- applicationWillEnterForeground ---")
    }

    // アプリを開いた時に呼ばれる
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("--- applicationDidBecomeActive ---")
    }

    // フリックしてアプリを終了させた時に呼ばれる
    func applicationWillTerminate(_ application: UIApplication) {
        print("--- applicationWillTerminate ---")
    }


}

