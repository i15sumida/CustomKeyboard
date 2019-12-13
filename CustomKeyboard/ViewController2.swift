//
//  ViewController2.swift
//  CustomKeyboard
//
//  Created by 住田みらの on 2019/12/11.
//  Copyright © 2019 住田みらの. All rights reserved.
//
//  このプログラムはTerminalViewの操作をする.

import Foundation   // SwiftCoreなどのライブラリがリンクされる
import UIKit        // UIパーツを使用するのに必要

class ViewController2: UIViewController, KeyboardDelegate{

    // MARK:- 変数定義
    
    @IBOutlet var textview: UITextView!
    
    // ボタン追加view
    let keyboard = UIStackView(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
    // ボタン追加Viewの背景View
    let buttonBackView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
    
    // 追加するボタン一覧
    let escButton = UIButton(frame: CGRect())
    let ctrlButton = UIButton(frame: CGRect())
    let tabButton = UIButton(frame: CGRect())
    let upButton = UIButton(frame: CGRect())
    let downButton = UIButton(frame: CGRect())
    let leftButton = UIButton(frame: CGRect())
    let rightButton = UIButton(frame: CGRect())
    let keyDownButton = UIButton(frame: CGRect())
    
    // Ctrlボタン押下フラグ
    var ctrlKey = false
    // 通常キーボードとCustomKeyboardを切り替えるフラグ
    var Keyflag = 0

    
    // MARK:- override func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--- viewDidLoad ---")
        //BleManager?.setView(self)           // BLEManagerでViewControllerのインスタンスを作成するため
    }
      
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("--- didReceiveMemoryWarning ---")
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- その他メソッド
    
    //keyboard delegate protocol　にメソッドを要求
    func keyWasTapped(character: String) {

        bleManager?.write(character)
 
    }
    
    // 画面遷移：nextView -> TerminalView
    @IBAction func goBack(_ segue:UIStoryboardSegue) {}
    
    // 画面遷移：TerminalView -> firstView

    @IBAction func goFirst(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 画面遷移：TerminalView -> nextView(キーボード仕様)
    @IBAction func goNext(_ sender:UIButton) {
           let next = storyboard!.instantiateViewController(withIdentifier: "nextView")
           self.present(next,animated: true, completion: nil)
    }
    
    // CustomKeyButtonが押されたとき
    // sender : 押下ボタン
    @IBAction func CustomKeyTap(_ sender: UIButton) {
        if(Keyflag==0){
            // キーボードを隠す
            textview.resignFirstResponder()
            
            // 追加キーボードボタンを初期化
            textKeyInit()
        
            // textviewの枠線をグレーにする(幅：1)
            textview.layer.borderColor = UIColor.lightGray.cgColor
            textview.layer.borderWidth = 1
            
            // textviewの文字サイズ
            textview.font = UIFont.systemFont(ofSize: 15)

            // CustomKeyboardを表示
            let keyboardView = Keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 250))
            keyboardView.delegate = self
            textview.inputView = keyboardView
            
            // 次にCustomKeyを押したら通常キーボードに戻す
            Keyflag = 1;
            
        }else{
            textview.resignFirstResponder()                     // キーボードを隠す
            textview.layer.borderColor = UIColor.blue.cgColor   // textViewの枠線を青にする
            textview.layer.borderWidth = 1                      // 幅：1
            Keyflag = 0;                                        // 次にCustomKeyを押したらCustomKeyboardにする
            textview.inputView = nil                            // 通常キーボードに戻す
        }
    }
        
    /* キーボード追加ボタンイベント */
    
        // 追加ボタンESCが押されたとき
        @objc func escTapped() {
            print("--- esc ---")
    //        buttonColorChange(button: escButton)
    //        // ペリフェラルとつながっていないときは何もしない
    //        if BleManager?.outputCharacteristic == nil {
    //            return
    //        }
    //        // ペリフェラルにエスケープを書き込む
    //        BleManager.writePeripheral("\u{1b}")
        }
    //
    
        // 追加ボタンCtrlが押されたとき
        @objc func ctrlTapped() {
            print("--- ctrl ---")
    //        // コントロールキーフラグを反転させる
    //        ctrlKey.toggle()
    //        // コントロールボタンの背景を変更する
    //        if ctrlKey {
    //            print("ctrlKey : ON")
    //            ctrlButton.backgroundColor = UIColor.white
    //            ctrlButton.setTitleColor(UIColor.lightGray, for: .normal)
    //        }
    //        else {
    //            print("ctrlKey : OFF")
    //            ctrlButton.backgroundColor = UIColor.lightGray
    //            ctrlButton.setTitleColor(UIColor.white, for: .normal)
    //        }
        }
    //
        // 追加ボタンtabが押されたとき
        @objc func tabTapped() {
            print("--- tab ---")
    //        buttonColorChange(button: tabButton)
    //        // ペリフェラルとつながっていないときは何もしない
    //        if appDelegate.outputCharacteristic == nil {
    //            return
    //        }
    //        // ペリフェラルにタブを書き込む
    //        writePeripheral("\t")
        }
    //
        // 追加ボタン↑が押されたとき
        @objc func upTapped() {
            print("--- up ---")
    //        buttonColorChange(button: upButton)
    //        // ペリフェラルとつながっていないときは何もしない
    //        if appDelegate.outputCharacteristic == nil {
    //            return
    //        }
    //        // ペリフェラルにエスケープシーケンスを書き込む
    //        writePeripheral("\u{1b}[A")
        }
    //
        // 追加ボタン↓が押されたとき
        @objc func downTapped() {
            print("--- down ---")
    //        buttonColorChange(button: downButton)
    //        // ペリフェラルとつながっていないときは何もしない
    //        if appDelegate.outputCharacteristic == nil {
    //            return
    //        }
    //        // ペリフェラルにエスケープシーケンスを書き込む
    //        writePeripheral("\u{1b}[B")
        }
    //
        // 追加ボタン←が押されたとき
        @objc func leftTapped() {
            print("--- left ---")
    //        buttonColorChange(button: leftButton)
    //        // ペリフェラルとつながっていないときは何もしない
    //        if appDelegate.outputCharacteristic == nil {
    //            return
    //        }
    //        // ペリフェラルにエスケープシーケンスを書き込む
    //        writePeripheral("\u{1b}[D")
        }
    //
        // 追加ボタン→が押されたとき
        @objc func rightTapped() {
            print("--- right ---")
    //        buttonColorChange(button: rightButton)
    //        // ペリフェラルとつながっていないときは何もしない
    //        if appDelegate.outputCharacteristic == nil {
    //            return
    //        }
    //        // ペリフェラルにエスケープシーケンスを書き込む
    //        writePeripheral("\u{1b}[C")
        }
    //
        // キーボード追加ボタンの背景色を変更する関数
        // button : 変更対象ボタン
        func buttonColorChange(button: UIButton) {
            // ボタンの背景を変更する
            button.backgroundColor = UIColor.white
            UIView.animate(withDuration: TimeInterval(0.3)) {
                button.backgroundColor = UIColor.lightGray
            }
        }
        
        // 追加キーボードボタンを初期化する関数
        func textKeyInit() {
            print("--- textKeyInit ---")
            // ボタンを追加するViewの設定
            keyboard.axis = .horizontal
            keyboard.alignment = .center
            keyboard.distribution = .fillEqually
            keyboard.spacing = 3
            keyboard.sizeToFit()
            
            // ボタン追加Viewの背景用Viewの設定
            buttonBackView.backgroundColor = UIColor.gray
            buttonBackView.sizeToFit()
            
            // エスケープキーの設定
            escButton.backgroundColor = UIColor.lightGray
            escButton.setTitle("ESC", for: UIControl.State.normal)
            escButton.addTarget(self, action: #selector(escTapped), for: UIControl.Event.touchUpInside)
            
            // コントロールキーの設定
            ctrlButton.backgroundColor = UIColor.lightGray
            ctrlButton.setTitle("Ctrl", for: UIControl.State.normal)
            ctrlButton.addTarget(ViewController(), action: #selector(ctrlTapped), for: UIControl.Event.touchUpInside)
            
            // タブキーの設定
            tabButton.backgroundColor = UIColor.lightGray
            tabButton.setTitle("tab", for: UIControl.State.normal)
            tabButton.addTarget(self, action: #selector(tabTapped), for: UIControl.Event.touchUpInside)
            
            // 上矢印キーの設定
            upButton.backgroundColor = UIColor.lightGray
            upButton.setTitle("↑", for: UIControl.State.normal)
            upButton.addTarget(self, action: #selector(upTapped), for: UIControl.Event.touchUpInside)
            
            // 下矢印キーの設定
            downButton.backgroundColor = UIColor.lightGray
            downButton.setTitle("↓", for: UIControl.State.normal)
            downButton.addTarget(self, action: #selector(downTapped), for: UIControl.Event.touchUpInside)
            
            // 左矢印キーの設定
            leftButton.backgroundColor = UIColor.lightGray
            leftButton.setTitle("←", for: UIControl.State.normal)
            leftButton.addTarget(self, action: #selector(leftTapped), for: UIControl.Event.touchUpInside)
            
            // 右矢印キーの設定
            rightButton.backgroundColor = UIColor.lightGray
            rightButton.setTitle("→", for: UIControl.State.normal)
            rightButton.addTarget(self, action: #selector(rightTapped), for: UIControl.Event.touchUpInside)
            
            
            // ボタンをViewに追加する
            keyboard.addArrangedSubview(escButton)
            keyboard.addArrangedSubview(ctrlButton)
            keyboard.addArrangedSubview(tabButton)
            keyboard.addArrangedSubview(upButton)
            keyboard.addArrangedSubview(downButton)
            keyboard.addArrangedSubview(leftButton)
            keyboard.addArrangedSubview(rightButton)
            
            // ボタンViewに背景をつける
            buttonBackView.addSubview(keyboard)
            
            // textViewと紐付ける
            textview.inputAccessoryView = buttonBackView
        }
    
}
