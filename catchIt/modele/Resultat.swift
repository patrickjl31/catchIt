//
//  Resultat.swift
//  catchIt
//
//  Created by patrick lanneau on 21/07/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import Foundation

class Resultat:Codable{
    private var _date:Date
    private var _niveau:Int
    private var _motCible: String
    private var _succes: Bool
    private var _nombreDeTaps : Int
    
    
    var niveau:Int {
        return _niveau
    }
    var motCible: String {
        return _motCible
    }
    
    var succes: Bool {
        return _succes
    }
    var nombreDeTaps : Int {
        return _nombreDeTaps
    }
    var date:Date {
        return _date
    }
    
    
    init (niveau:Int, motCible:String, succes:Bool, taps:Int){
        self._date = Date()
        self._niveau = niveau
        self._motCible = motCible
        self._succes = succes
        self._nombreDeTaps = taps
    }
}
