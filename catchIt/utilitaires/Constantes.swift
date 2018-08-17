//
//  Constantes.swift
//  catchIt
//
//  Created by patrick lanneau on 25/07/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import Foundation
import  UIKit

let FONT_DE_BASE = UIFont(name: "Chalkduster", size: 15)
let FONT_TITRE = UIFont(name: "Chalkduster", size: 20)


let BLANC = UIColor.white
let GRIS_TRES_CLAIR = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)
let GRIS_TRES_FONCE = UIColor(red: 30 / 255, green: 30 / 255, blue: 30 / 255, alpha: 1)

// Nombre de mots parmi lesquels chercher celui qui est cache
let NOMBRE_MOTS_AFFICHABLES = 10

// nombre d'essai possibles dans une casse au mot
let NOMBRE_ESSAIS_POSSIBLES = 40

enum vitesseEclair : Double {
    case lent = 0.5
    case moyen = 0.25
    case rapide = 0.2
}

// Gestion de fichiers
let KEY_JOUEUR = "nomJoueur"


// Emoji
let directHit = "🎯"
let redCircle = "🔴"


//Les cellules de la table des noms
let CELL_NOMS = "nameCell"
