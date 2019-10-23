//
//  Keyboard.swift
//  CustomKeyboard
//
//  Created by 住田みらの on 2019/10/08.
//  Copyright © 2019 住田みらの. All rights reserved.
//

import Foundation
import UIKit

// The view controller will adopt this protocol (delegate)
// and thus must contain the keyWasTapped method
protocol KeyboardDelegate: class {
    func keyWasTapped(character: String)
}

class Keyboard: UIView {

    // MARK:- 変数定義
    
    weak var delegate: KeyboardDelegate?
    
    var KeyFlag = 100;

    @IBOutlet var NO: UIButton!
    
    // MARK:- keyboard 初期化

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }

    func initializeSubviews() {
        
        if(KeyFlag == 100){
            let xibFileName = "Keyboard" // xib extention not included
            let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
                self.addSubview(view)
                view.frame = self.bounds
        }else if(KeyFlag == 200){
            let xibFileName = "Keyboard2" // xib extention not included
            let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
                self.addSubview(view)
                view.frame = self.bounds
        }else if(KeyFlag == 300){
            let xibFileName = "Keyboard3" // xib extention not included
            let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
                self.addSubview(view)
                view.frame = self.bounds
        }
    }
    

    // MARK:- ボタンアクション
    
    @IBAction func keyTapped(sender: UIButton) {
        // When a button is tapped, send that information to the
        // delegate (ie, the view controller)
        let tagnumber:UIButton = sender as UIButton
        print("タグナンバーは\(tagnumber.tag),KeyFlagは\(KeyFlag)です。")     //確認用
        
        //-------------------どのキーボードにも共通のキー(tagが一桁)-----------------//
        if(tagnumber.tag < 100){
            if(tagnumber.tag == 0){
                self.delegate?.keyWasTapped(character: sender.titleLabel!.text!)        //ボタン名を出力
                
            }else if(tagnumber.tag == 1){                               //tabキー
                self.delegate?.keyWasTapped(character: "\t")
                
            }else if(tagnumber.tag == 2){                               //Returnキー
                self.delegate?.keyWasTapped(character: "\r\n")
                
            }else if(tagnumber.tag == 3){                               //Spaceキー
                self.delegate?.keyWasTapped(character: " ")
                
            }else if(tagnumber.tag == 4){                               //Deleteキー
                self.delegate?.keyWasTapped(character: "\u{08}")
                self.delegate?.keyWasTapped(character: "")
                
            }
        }
        //------------------------Keyboard(tagが100以上200未満)--------------------------//
        if(tagnumber.tag >= 100 && tagnumber.tag < 200){
            if(tagnumber.tag == 100){                               //Keyboard -> Keyboard2
                print("Keyboard -> Keyboard2")
                KeyFlag = 200;
                initializeSubviews()
            }else if(tagnumber.tag == 101){
                self.delegate?.keyWasTapped(character: "NO")         //NO
            }else if(tagnumber.tag == 102){
                self.delegate?.keyWasTapped(character: "ADD\t")      //ADD + tab
            }else if(tagnumber.tag == 103){
                self.delegate?.keyWasTapped(character: "AND\t")      //AND + tab
            }else if(tagnumber.tag == 104){
                self.delegate?.keyWasTapped(character: "SHLA\t")     //SHLA + tab
            }else if(tagnumber.tag == 105){
                self.delegate?.keyWasTapped(character: "JZ\t")       //JZ + tab
            }else if(tagnumber.tag == 106){
                self.delegate?.keyWasTapped(character: "JMP\t")      //JMP + tab
            }else if(tagnumber.tag == 107){
                self.delegate?.keyWasTapped(character: "JNZ\t")      //JNZ + tab
            }else if(tagnumber.tag == 108){
                self.delegate?.keyWasTapped(character: "IN\t")       //IN + tab
            }else if(tagnumber.tag == 109){
                self.delegate?.keyWasTapped(character: "PUSH\t")     //PUSH + tab
            }else if(tagnumber.tag == 110){
                self.delegate?.keyWasTapped(character: "POP\t")      //POP + tab
            }else if(tagnumber.tag == 111){
                self.delegate?.keyWasTapped(character: "EI")         //EI
            }else if(tagnumber.tag == 112){
                self.delegate?.keyWasTapped(character: "RET")        //RET
            }
        }
        //------------------------Keyboard2(tagが200以上)--------------------------//
        else if(tagnumber.tag == 200){                              //Keyboard2 -> Keyboard
            print("Keyboard2 -> Keyboard")
            KeyFlag = 100;
            initializeSubviews()
        }else if(tagnumber.tag == 220){                             //Keyboard2 -> Keyboard3
            print("Keyboard2 -> Keyboard3")
            KeyFlag = 300;
            initializeSubviews()
        //------------------------Keyboard3(tagが300以上)--------------------------//
        }else if(tagnumber.tag == 300){                              //Keyboard3 -> Keyboard
            print("Keyboard3 -> Keyboard")
            KeyFlag = 100;
            initializeSubviews()

        }else if(tagnumber.tag == 330){                             //Keyboard3 -> Keyboard2
            print("Keyboard3 -> Keyboard2")
            KeyFlag = 200;
            initializeSubviews()
        }
    }
    
}
