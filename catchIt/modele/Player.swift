//
//  Player.swift
//  catchIt
//
//  Created by patrick lanneau on 20/07/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import Foundation

class Player: Codable {
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
}
