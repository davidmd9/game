//
//  ViewController.swift
//  GameTimeKill
//
//  Created by David Minasyan on 11.11.17.
//  Copyright © 2017 David Minasyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tab1_View: UIView!
    @IBOutlet weak var tab2_View: UIView!
    @IBOutlet weak var tab3_View: UIView!
    @IBOutlet weak var tab4_View: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var numStr = 0
    
    var strViewTab1 = [UIView]()
    var gameModel = GameModel()
    var words = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsKeyboard()
        words = gameModel.createField(letter: "А")
        getAllStrTable(table: tab1_View)
        getAllStrTable(table: tab2_View)
        getAllStrTable(table: tab3_View)
        getAllStrTable(table: tab4_View)
        
    }
    
    //MARK: - Получаем все строки(view) со всех таблиц и каждой view задаем tag = numStr
    func getAllStrTable(table: UIView){
        for view in table.subviews{
            view.tag = numStr
            setTagTextField(strView: view)
            numStr+=1
        }
    }
    
    //MARK: - Получаем все textField из строк view, задаем начальные значения textField и устанавливаем tag = numCol in string View
    func setTagTextField(strView: UIView){
        var numCol = 0
        
        for letterView in strView.subviews{
            let textField = letterView.subviews[0] as! UITextField
            textField.tag = numCol
            if words[numStr][numCol] != " "{
                textField.text = words[numStr][numCol]
                textField.isEnabled = false
                textField.superview?.backgroundColor = UIColor.yellow
            }
            else{
                textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                textField.delegate = self
            }
            numCol+=1
        }
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        if textField.text != ""{
            let value = textField.text?[(textField.text?.characters.count)!-1]
            textField.text = value
        }
        textField.text = textField.text?.uppercased()
        if textField.text == ""{
            textField.text = " "
        }
        let (wordsDone, _, gameDone ) = gameModel.addLetter(letter: textField.text!, letterNumber: textField.tag, wordNumber: (textField.superview?.superview?.tag)!)
        if wordsDone{
            textField.superview?.superview?.backgroundColor = UIColor.lightGray
            setAllEdetingTextFiled(view: textField.superview!.superview!)
        }
        _ = moveToNextLetter(textField: textField)
        
        if gameDone {
            print("ура")
        }
    }
    
    func  setAllEdetingTextFiled(view: UIView){
        for view in view.subviews{
            let textFiled = view.subviews[0] as! UITextField
            textFiled.isEnabled = false
        }
    }
    
    
    
    
    //MARK: - Настройка дейстий с клавиатурой
    func settingsKeyboard(){
        //event open keyboard
        registerForKeyboardNotification()
        
        //dissmis keyBoard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        //event свернуть клавиатуру если был тап в пустую область
        view.addGestureRecognizer(tap)
    }
    
    func registerForKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func kbWillShow(_ notification: Notification){
        

        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height+24
        scrollView.contentInset = contentInset
    }
    
    @objc func kbWillHide(_ notification: Notification){
//        scrollView.contentOffset = CGPoint.zero
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        scrollView.resignFirstResponder() //прячем клавиатуру
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return moveToNextLetter(textField: textField)
    }
    
    func moveToNextLetter(textField: UITextField) -> Bool{
        if textField.tag < ((textField.superview?.superview?.subviews.count)!-1) {
            var index = 1
            if !(textField.superview?.superview?.subviews[textField.tag+index].subviews[0] as! UITextField).isEnabled{
                if (textField.superview?.superview?.subviews.count)!-1 > textField.tag+index{
                    index = 2
                }
            }
            (textField.superview?.superview?.subviews[textField.tag+index].subviews[0] as! UITextField).becomeFirstResponder()
        
            return true
        }
        self.view.endEditing(true)
        return false
    }
    
    
    
    func removeNotificationKeyBoard(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    deinit {
        removeNotificationKeyBoard()
    }


}

extension String{
    subscript (i:Int) -> String?{
        if characters.count > i && i >= 0{
            return String(Array(self.characters)[i])
        }
        return nil
    }
    
    subscript (r : Range<Int>) -> String?{
        guard r.lowerBound>=0 && r.upperBound <= self.characters.count && r.lowerBound <= r.upperBound else {return nil}
        let start = self.index(startIndex, offsetBy: r.lowerBound)
        let end = self.index(startIndex, offsetBy: r.upperBound)
        return self[Range(start ..< end)]
        
    }
    
    func indexAt(i : Int) -> String.Index?{
        if characters.count > i{
            return index(self.startIndex, offsetBy: i)
        }
        return nil
    }
}

