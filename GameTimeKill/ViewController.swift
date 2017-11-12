//
//  ViewController.swift
//  GameTimeKill
//
//  Created by David Minasyan on 11.11.17.
//  Copyright © 2017 David Minasyan. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation


class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var main_View: UIView!
    @IBOutlet weak var tab1_View: UIView!
    @IBOutlet weak var tab2_View: UIView!
    @IBOutlet weak var tab3_View: UIView!
    @IBOutlet weak var tab4_View: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var time_Label: UILabel!
    
    var numStr = 0
    var timeBegin : Int64 = 0
    
    var strViewTab1 = [UIView]()
    var gameModel = GameModel()
    var words = [String]()
    var player : AVAudioPlayer?
    var level : Int = 0
    let letters = UserLetters.getInstance()
    
    var gameTimer: Timer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        statusBar?.backgroundColor = UIColor.clear
        
        settingsKeyboard()
        words = gameModel.createField(letter: letters.getKeys().aLet[level].letter.uppercased())
        getAllStrTable(table: tab1_View)
        getAllStrTable(table: tab2_View)
        getAllStrTable(table: tab3_View)
        getAllStrTable(table: tab4_View)
        
        if timeBegin == 0{
           timeBegin = Int64(Date().millisecondsSince1970)
        }
        
        runTimedCode()
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }

    func runTimedCode(){
        time_Label.text = convertMsecToDate(msec: (Int64(Date().millisecondsSince1970)-timeBegin))
    }
    
    func convertMsecToDate(msec: Int64) -> String{
        let sec = msec/1000
        let date = Date(timeIntervalSince1970: TimeInterval(sec))
        let dateFormmat = DateFormatter()
        dateFormmat.dateFormat = "HH:mm:ss"
        dateFormmat.timeZone = TimeZone.init(identifier: "UTC")
        return dateFormmat.string(from: date)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (UIApplication.shared.delegate as! AppDelegate).getSoundEnabled(){
            playSound()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard player != nil else {return}
        if (player?.isPlaying)!{
            player?.stop()
        }
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
                textField.superview?.backgroundColor = UIColor.init(red: 1.0, green: 0.8, blue: 0, alpha: 0.8)
            }
            else{
                textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                textField.delegate = self
            }
            numCol+=1
        }
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        if (UIApplication.shared.delegate as! AppDelegate).getVibrationEnabled() {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
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
//            textField.superview?.superview?.backgroundColor = UIColor.lightGray
            setAllEdetingTextFiled(view: textField.superview!.superview!)
        }
        _ = moveToNextLetter(textField: textField)
        
        if gameDone {
            nextLevel()
        }
    }
    
    func  setAllEdetingTextFiled(view: UIView){
        for view in view.subviews{
            let textFiled = view.subviews[0] as! UITextField
            textFiled.backgroundColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.6, alpha: 0.8)
            textFiled.isEnabled = false
        }
    }
    
    
    func nextLevel(){
        if level < letters.getKeys().aLet.count-1{
            saveLavelUserDef()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NextLevelID") as! NextLevelViewController
            controller.level = level + 1
            controller.timeBegin = timeBegin
            self.present(controller, animated: true, completion: nil)
        }
        if gameTimer.isValid{
            gameTimer.invalidate()
        }
    }
    
    func saveLavelUserDef(){
       _ = letters.openLetter(letter: letters.getKeys().aLet[level+1].letter)
    }
    
    func showAlert(){
        let alertController = UIAlertController(title: "Внимание", message: "Вы действительно хотите завершить игру?", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Да", style: .default) { (UIAlertAction) in
            self.mainActivity_Transition()
        }
        let actionNo = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        alertController.addAction(actionYes)
        alertController.addAction(actionNo)
        present(alertController, animated: true, completion: nil)
    }
    
    func mainActivity_Transition(){
        if gameTimer.isValid{
            gameTimer.invalidate()
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainVCID")
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func breakGame(_ sender: UIButton) {
        showAlert()
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

    func playSound() {
        let url = Bundle.main.url(forResource: "music", withExtension: "mp3")
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            player = try AVAudioPlayer(contentsOf: url!)
            guard let player = player else { return }
            player.numberOfLoops = -1
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
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

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}


