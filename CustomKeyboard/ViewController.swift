//
//  ViewController.swift
//  CustomKeyboard
//
//  Created by 住田みらの on 2019/10/08.
//  Copyright © 2019 住田みらの. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, KeyboardDelegate {

    // MARK:- 変数定義
    
    @IBOutlet var textView: UITextView!
    
    @IBOutlet var testLabel: UILabel!
    
    // MARK:- override func
    
    //textView 以外のところをタップするとキーボードが隠れる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //キーボードを隠すやつ
        textView.delegate = self as? UITextViewDelegate
        
        // textViewに枠線をつける
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        
        // textViewの文字サイズ
        textView.font = UIFont.systemFont(ofSize: 18)

        
        // CustomKeyboardを表示
        let keyboardView = Keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 300))
        keyboardView.delegate = self // the view controller will be notified by the keyboard whenever a key is tapped
        textView.inputView = keyboardView
    }
    
    // MARK:- その他メソッド
    
    //keyboard delegate protocol　にメソッドを要求
    func keyWasTapped(character: String) {
            textView.insertText(character)
        //Bluetoothに送るメソッドを書く予定
        
    }
    
}
