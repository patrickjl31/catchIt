//
//  Player.swift
//  catchIt
//
//  Created by patrick lanneau on 20/07/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import Foundation

class Player: Codable, Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs._nom == rhs.nom
    }
    
    private var _nom : String
    private var _score : Int = 0
    var resultats:[Resultat] = []
    
    var nom: String {
        return _nom
    }
    var score: Int {
        return _score
    }
    
    init(nom:String) {
        self._nom = nom
    }
    
    func incrementScore(){
        _score += 1
    }
    
    func ajoutPartie(res:Resultat)  {
        resultats.insert(res, at: 0)
    }
    
    func removePartie(pos:Int)  {
        if pos > -1,
            pos < resultats.count {
            resultats.remove(at: pos)
        }
        
    }
}
