//
//  GameModelInterface.swift
//  GameTimeKill
//
//  Created by David Minasyan on 11.11.17.
//  Copyright © 2017 David Minasyan. All rights reserved.
//

import Foundation



class GameWord {
    var word: String = ""
    var defaultWord: String = ""
    var length: Int = 0
    var letterIndex: Int = 0
    var isInit: Bool = false
    var isFilled: Bool = false
    
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
    
    public func getWord() -> String{
        return word
    }
    
    public func addLetter(letter: String, position: Int) -> Bool{
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
    
}

class GameField {
    var words : [GameWord]?
    var maxFiled = 0
    var minField = 0
    var sizes = [(size: Int, startIndex: Int, endIndex: Int)]()
    
    public init(with letter: String, maxField: Int, minField: Int){
        if (maxField>minField){
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
    
    public func checkWordExistance(word: String) -> Bool{
        for sz in sizes{
            if sz.size == word.characters.count{
                let startIndex = sz.startIndex
                let endIndex = sz.startIndex+sz.endIndex
                var i = startIndex
                while i<endIndex {
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
    
}

class GameModel {
    
    let rusLoc = Locale(identifier: "ru_RU")
    var game : GameField?
    
    
    public func createField(letter:String) -> [String]{
        game = GameField(with: letter, maxField: 6, minField: 3)
        guard game != nil else {
            return []
        }
        return game!.getStringArray()
    }
    
    public func addLetter(letter: String, posX: Int, posY: Int, tableIndex: Int) -> (Bool, Bool, Bool){
        return (true, true, false)
    }
    
    public func getMatrix(matrixIndex: Int) -> [String]{
        let  v = [String]()
        return (v)
    }
    
}
