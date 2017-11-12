//
//  UserLetters.swift
//  GameTimeKill
//
//  Created by David Minasyan on 11.11.17.
//  Copyright © 2017 David Minasyan. All rights reserved.
//

import Foundation


struct aLetter {
    var letter: String
    var isActve: Bool
}

class UserLetters {
    
    private static var instance: UserLetters?
    private static let KEY = "EMPTY"
    private static let ltrs = ["А","О","Е","У","И","Д","В","Р","М","К","Л","Х","З","С","Т","Ч","Я","З"]
    private var letters = [aLetter]()
    
    //letter initializer
    private func initLetters() -> [aLetter]{
        var letters = [aLetter]()
        for lt in UserLetters.ltrs {
            let newLetter = aLetter(letter: lt, isActve: false)
            letters.append(newLetter)
        }
        self.letters = letters
        return letters
    }
    
    // private constructor
    private init() {
        let defaults = UserDefaults.standard
        if (defaults.array(forKey: UserLetters.KEY) == nil){
            defaults.set(initLetters(), forKey: UserLetters.KEY)
        }
        letters = defaults.array(forKey: UserLetters.KEY) as! [aLetter]
    }
    
    // return keys
    public func getKeys() -> [aLetter]{
        if (letters.count > 0){
            letters = UserDefaults.standard.array(forKey: UserLetters.KEY) as! [aLetter]
        }
        return letters
    }
    
    // return instance of object
    public static func getInstance() -> UserLetters{
        if (instance != nil){
            return instance!
        } else {
            instance = UserLetters()
            return instance!
        }
    }
    
    // записать буквы
    private func writeLetters(){
        let defaults = UserDefaults.standard
        defaults.set(letters, forKey: UserLetters.KEY)
    }
    
    // open letter to user
    public func openLetter(letter: String) -> Bool{
        var i = 0
        while i < letters.count {
            if (letters[i].letter == letter) {
                letters[i].isActve = true
                writeLetters()
                return true
            }
            i += 1
        }
        return false
    }
    
}
