//
//  Keyboard.swift
//  CustomKeyboard
//
//  Created by 住田みらの on 2019/10/08.
//  Copyright © 2019 住田みらの. All rights reserved.
//

import Foundation
import UIKit

protocol KeyboardDelegate: class {
    func keyWasTapped(character: String)
}

class Keyboard: UIView {

    // MARK:- 変数定義
    
    weak var delegate: KeyboardDelegate?
    var KeyFlag = 200
    
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
            let xibFileName = "Keyboard"
            let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
                self.addSubview(view)
                view.frame = self.bounds
        }else if(KeyFlag == 200){
            let xibFileName = "Keyboard2"
            let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
                self.addSubview(view)
                view.frame = self.bounds
        }else if(KeyFlag == 300){
            let xibFileName = "Keyboard3"
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
                
            }else if(tagnumber.tag == 2){                               //Returnキー
                self.delegate?.keyWasTapped(character: "\r\n")
                
            }else if(tagnumber.tag == 3){                               //Spaceキー
                self.delegate?.keyWasTapped(character: " ")
                
            }else if(tagnumber.tag == 4){                               //Deleteキー
                self.delegate?.keyWasTapped(character: "")
            }else if(tagnumber.tag == 5){                               //レジスタ(G0)キー
                self.delegate?.keyWasTapped(character: "GO")
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
                self.delegate?.keyWasTapped(character: "PUSH\t")     //PUSH + tab
            }else if(tagnumber.tag == 109){
                self.delegate?.keyWasTapped(character: "POP\t")      //POP + tab
            }else if(tagnumber.tag == 110){
                self.delegate?.keyWasTapped(character: "EI")         //EI
            }else if(tagnumber.tag == 111){
                self.delegate?.keyWasTapped(character: "RET")        //RET
            }else if(tagnumber.tag == 112){
                self.delegate?.keyWasTapped(character: "DC\t")       //DC + tab
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
        }else if(tagnumber.tag == 300){                             //Keyboard3 -> Keyboard
            print("Keyboard3 -> Keyboard")
            KeyFlag = 100;
            initializeSubviews()

        }else if(tagnumber.tag == 330){                             //Keyboard3 -> Keyboard2
            print("Keyboard3 -> Keyboard2")
            KeyFlag = 200;
            initializeSubviews()
        }
    }

    //----------------------------スワイプアクション-----------------------------------------//
    
    @IBAction func LD(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "LD\t")    //LD + tab
    }
    @IBAction func ST(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "ST\t")    //ST + tab
    }
    @IBAction func SUB(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "SUB\t")   //SUB + tab
    }
    @IBAction func CMP(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "CMP\t")   //CMP + tab
    }
    @IBAction func OR(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "OR\t")    //OR + tab
    }
    @IBAction func XOR(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "XOR\t")   //XOR + tab
    }
    @IBAction func SHLL(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "SHLL\t")  //SHLL + tab
    }
    @IBAction func SHRA(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "SHRA\t")  //SHRA + tab
    }
    @IBAction func SHRL(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "SHRL\t")  //SHRL + tab
    }
    @IBAction func JC(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "JC\t")    //JC + tab
    }
    @IBAction func JM(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "JM\t")    //JM + tab
    }
    @IBAction func CALL(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "CALL\t")  //CALL + tab
    }
    @IBAction func JNC(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "JNC\t")   //JNC + tab
    }
    @IBAction func JNM(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "JNM\t")   //JNM + tab
    }
    @IBAction func OUT(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "OUT\t")   //OUT + tab
    }
    @IBAction func PUSHF(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "PUSHF\t") //PUSHF + tab
    }
    @IBAction func POPF(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "POPF\t")  //POPF + tab
    }
    @IBAction func EI(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "DI")      //EI
    }
    @IBAction func DI(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "DI")      //DI
    }
    @IBAction func RETI(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "RETI")    //RETI
    }
    @IBAction func HALT(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "HALT")    //HALT
    }
    @IBAction func G1_Keyboard(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "G1")      //G1
    }
    @IBAction func G2_Keyboard(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "G2")      //G2
    }
    @IBAction func SP_Keyboard(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "SP")      //SP
    }
    @IBAction func G1_Keyboard2(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "G1")      //G1
    }
    @IBAction func G2_Keyboard2(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "G2")      //G2
    }
    @IBAction func SP_Keyboard2(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "SP")      //SP
    }
    @IBAction func G1_Keyboard3(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "G1")      //G1
    }
    @IBAction func G2_Keyboard3(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "G2")      //G2
    }
    @IBAction func SP_Keyboard3(_ sender: Any) {
        self.delegate?.keyWasTapped(character: "SP")      //SP
    }
    
}
