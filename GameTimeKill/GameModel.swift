//
//  GameModelInterface.swift
//  GameTimeKill
//
//  Created by David Minasyan on 11.11.17.
//  Copyright © 2017 David Minasyan. All rights reserved.
//

import Foundation
import UIKit



fileprivate class GameWord {
    var word: String = ""
    var defaultWord: String = ""
    var length: Int = 0
    var letterIndex: Int = 0
    var isInit: Bool = false
    var isFilled: Bool = false
    
    
    // One word initialization
    public init(with letter: String, index: Int, length: Int) {
        var i = 0
        while i<length {
            if (i==index){
                defaultWord.append(letter)
            } else {
                defaultWord.append(" ")
            }
            i += 1
        }
        word = "\(defaultWord)"
        self.length = length
        letterIndex = index
        isInit = true
    }
    
    // returns string value of word
    public func getWord() -> String{
        return word
    }
    
    // adds letter to specified position
    public func addLetter(letter: String, position: Int) -> Bool{
        if (isFilled){
            return false
        }
        if (position != letterIndex){
            var chars = Array(word.characters)
            let char2 = Array(letter.characters)
            chars[position] = char2[0]
            word = String(chars)
            return true
        } else {
            return false
        }
    }
    
    // trys to add letter
    public func tryAddLetter(letter: String, position: Int) -> String?{
        
        if (position != letterIndex){
            var chars = Array(word.characters)
            let char2 = Array(letter.characters)
            chars[position] = char2[0]
            let tempWord = String(chars)
            return tempWord
        } else {
            return nil
        }
        
    }
    
    // check if word exists in dictionary
    public func checkIfWordExists() -> Bool{
        if isFilled {
            return isFilled
        }
        if (GameField.dict == nil) {
            GameField.reloadDict()
        }
        for w in GameField.dict!{
            if w == self.word {
                isFilled = true
                return true
            }
        }
        return false
    }
    
}

fileprivate class GameField {
    var words : [GameWord]?
    var maxFiled = 0
    var minField = 0
    var sizes = [(size: Int, startIndex: Int, endIndex: Int)]()
    static let filePath = Bundle.main.url(forResource: "word_rus", withExtension: "txt")
    static var dict : [String]?
    
    static let rusLoc = Locale(identifier: "ru_RU")

    
    // static method to reload data
    public static func reloadDict() -> Bool{
        do {
            if (GameField.dict == nil){
                try GameField.dict = String(contentsOf: GameField.filePath!).uppercased(with: GameField.rusLoc).components(separatedBy: "\n")
            }
            return true
        } catch {
            return false
        }
    }
    
    // Initialization
    public init(with letter: String, maxField: Int, minField: Int){
        if (maxField>minField){
                if (GameField.dict == nil){
                    GameField.reloadDict()
                }
                
                words = [GameWord]()
                var i = maxField;
                var line = 0;
                while i >= minField {
                    var j = 0
                    sizes.append((size: i, startIndex: line, endIndex: line+i-1))
                    while j < i {
                        let w:GameWord = GameWord(with: letter, index: j, length: i)
                        words?.append(w)
                        line += 1
                        j += 1
                    }
                    print(i)
                    i -= 1
                }
                self.maxFiled = maxField
                self.minField = minField
        }
    }
    
    // returns tring array
    public func getStringArray() -> [String]{
        var res = [String]()
        guard words != nil else{
            return res
        }
        for a in self.words!{
            res.append(a.getWord())
        }
        return res
    }
    
    // check if words are equal
    public func checkSameWordExistance(word: String) -> Bool{
        for sz in sizes{
            if sz.size == word.characters.count{
                let startIndex = sz.startIndex
                let endIndex = sz.endIndex
                var i = startIndex
                while i<=endIndex {
                    if (words?[i].getWord() == word){
                        return true
                    }
                    i += 1
                }
                return false
            }
        }
        return false
    }
    
    // adds letter
    public func addLetter(letter: String, letterNumber: Int, wordNumber: Int) -> Bool{
        let s = words?[wordNumber].tryAddLetter(letter: letter, position: letterNumber)
        if !checkSameWordExistance(word: s!){
            if (words?[wordNumber].addLetter(letter: letter, position: letterNumber))! {
                return true
            }
        }
        return false
    }
    
    // chek if word is done
    public func isWordDone(wordNumber: Int) -> Bool {
        if ( (words?[wordNumber])!).checkIfWordExists() {
            return true
        } else {
            return false
        }
    }
    
    // check if block is done
    public func isBlockDone(wordNumber: Int) -> Bool{
        for s in sizes{
            if wordNumber >= s.startIndex && wordNumber < s.endIndex{
                var i = 0
                while  i<s.endIndex {
                    if !(words?[i].checkIfWordExists())! {
                        return false
                    }
                    i += 1
                }
                return true
            }
        }
        return false
    }
    
    // check if field is done
    public func isFieldDone() -> Bool{
        for w in words!{
            if !w.checkIfWordExists(){
                return true
            }
        }
        return false
    }
    
}

class GameModel {
    
    let rusLoc = Locale(identifier: "ru_RU")
    fileprivate var game : GameField?
    
    let tf = UITextField()
    
    
    public func createField(letter:String) -> [String]{
        let ltr = letter.uppercased(with: rusLoc)
        game = GameField(with: ltr, maxField: 6, minField: 3)
        guard game != nil else {
            return []
        }
        return game!.getStringArray()
    }
    
    public func addLetter(letter: String, letterNumber: Int, wordNumber: Int) -> (Bool, Bool, Bool){
        let ltr = letter.uppercased(with: rusLoc)
        if (game?.addLetter(letter: ltr, letterNumber: letterNumber, wordNumber: wordNumber))!{
            let wordDone = game?.isWordDone(wordNumber: wordNumber)
            let blockDone = game?.isBlockDone(wordNumber: wordNumber)
            let gameDone = game?.isFieldDone()
            return (wordDone!, blockDone!, gameDone!)
        }
        return (false, false, false)
    }
    
    public func getMatrix() -> [String]{
        return (game?.getStringArray())!
    }
    
}
