//
//  UserLetters.swift
//  GameTimeKill
//
//  Created by David Minasyan on 11.11.17.
//  Copyright © 2017 David Minasyan. All rights reserved.
//

import Foundation


class aLetter :NSObject, NSCoding{
    
    required init?(coder aDecoder: NSCoder) {
        self.letter = aDecoder.decodeObject(forKey:"letter") as? String ?? ""
        self.isActve = aDecoder.decodeBool(forKey: "isActive")
    }
    
    init(letter: String, isActive: Bool) {
        self.letter = letter
        self.isActve = isActive
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(letter, forKey: "letter")
        aCoder.encode(isActve, forKey: "isActive")
    }
    
    var letter: String = ""
    var isActve: Bool = false
}

class aLetters :NSObject, NSCoding{
    public var aLet = [aLetter]()
    override init() {
        
    }
    required init?(coder aDecoder: NSCoder) {
        self.aLet = aDecoder.decodeObject(forKey: "letters") as? [aLetter] ?? []
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(aLet, forKey: "letters")
    }
    
}

class UserLetters {
    
    private static var instance: UserLetters?
    private static let KEY = "EMPTY"
    private static let ltrs = ["А","О","Е","У","И","Д","В","Р","М","К","Л","Х","З","С","Т","Ч","Я","З"]
    private var letters = aLetters()
    
    //letter initializer
    private func initLetters() -> aLetters{
        for lt in UserLetters.ltrs {
            let newLetter = aLetter(letter: lt, isActive: false)
            letters.aLet.append(newLetter)
        }
        return letters
    }
    
    // private constructor
    private init() {
//        let defaults = UserDefaults.standard
//        if (defaults.array(forKey: UserLetters.KEY) == nil){
//            let sav = NSKeyedArchiver.archivedData(withRootObject: letters)
//            defaults.set(sav, forKey: UserLetters.KEY)
//        }
        if let data = UserDefaults.standard.data(forKey: UserLetters.KEY), let val = NSKeyedUnarchiver.unarchiveObject(with: data) as? aLetters{
            letters = val
        }
//        if let val = NSKeyedUnarchiver.unarchiveObject(with: (defaults.object(forKey: UserLetters.KEY) as? Data)!) as? aLetters{
//            letters = val
//        }
        if (letters.aLet.count<1){
           _ = initLetters()
        }
    }
    
    // return keys
    public func getKeys() -> aLetters{
        if (letters.aLet.count <= 0){
            let defaults = UserDefaults.standard
            letters = NSKeyedUnarchiver.unarchiveObject(with: defaults.object(forKey: UserLetters.KEY) as! Data) as! aLetters
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
        let sav = NSKeyedArchiver.archivedData(withRootObject: letters)
        defaults.set(sav, forKey: UserLetters.KEY)
    }
    
    // open letter to user
    public func openLetter(letter: String) -> Bool{
        var i = 0
        while i < letters.aLet.count {
            if (letters.aLet[i].letter == letter) {
                letters.aLet[i].isActve = true
                writeLetters()
                return true
            }
            i += 1
        }
        return false
    }
    
    public func getIndexOf(letter: String) -> Int? {
        var k = 0
        for a in letters.aLet {
            if (a.letter==letter){
                return k
            }
            k += 1
        }
        return nil
    }
    
}
