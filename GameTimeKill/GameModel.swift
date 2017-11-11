//
//  GameModelInterface.swift
//  GameTimeKill
//
//  Created by David Minasyan on 11.11.17.
//  Copyright © 2017 David Minasyan. All rights reserved.
//

import Foundation

class GameModel {
    public func createField(letter:String) -> ([String], Int){
        var v = [String]()
        var i = 0;
        while i<6 {
            v.append("      ")
            i += 1
        }
        return (v, 1)
    }
    
    public func addLetter(letter: String, posX: Int, posY: Int, tableIndex: Int) -> (Bool, Bool, Bool){
        return (true, true, false)
    }
    
    public func getMatrix(matrixIndex: Int) -> [String]{
        return
    }
    
}
