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

    @IBOutlet var textView: UITextView!
    
    @IBOutlet var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // textViewに枠線をつける
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        
        // textViewの文字サイズ
        textView.font = UIFont.systemFont(ofSize: 18)

        
        // initialize custom keyboard
        let keyboardView = Keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 300))
        keyboardView.delegate = self // the view controller will be notified by the keyboard whenever a key is tapped
    
        textView.inputView = keyboardView
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipe(_:)))
        rightSwipe.direction = .right
        self.testLabel.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipe(_:)))
        leftSwipe.direction = .left
        self.testLabel.addGestureRecognizer(leftSwipe)
        
    }
    
    // required method for keyboard delegate protocol
    func keyWasTapped(character: String) {
            textView.insertText(character)
        //Bluetoothに送るメソッドを書く予定
    }
    
    //スワイプ時の呼び出しメソッド
    @objc func didSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            testLabel.text = "右"
            textView.text += "右"
        }
        else if sender.direction == .left {
            testLabel.text = "左"
            textView.text += "左"
        }
    }
}
