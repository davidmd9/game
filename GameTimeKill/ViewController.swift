//
//  ViewController.swift
//  GameTimeKill
//
//  Created by David Minasyan on 11.11.17.
//  Copyright © 2017 David Minasyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tab1_View: UIView!
    @IBOutlet weak var tab2_View: UIView!
    @IBOutlet weak var tab3_View: UIView!
    @IBOutlet weak var tab4_View: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsKeyboard()
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
        scrollView.contentOffset = CGPoint.zero
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        scrollView.resignFirstResponder() //прячем клавиатуру
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //скрыть keyboard
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

