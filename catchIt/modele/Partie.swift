//
//  Partie.swift
//  catchIt
//
//  Created by patrick lanneau on 20/07/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import Foundation

//gere le modèle d'une partie


class Partie  {
    
    
    var motATrouver : String = ""
    var motCourantAVoir:String = ""
    //var listeCouranteMots:[String] = []
    var listeReduiteMots:[String] = []
    //var level:Int = 3
    
    // cette classe gère les enregistrements et les utilisateurs
    //var files:GestionFiles
    
    // Varialbes de service
    // nombreDePresentations est le nombre de mots présentés dans la partie
    var nombreDePresentations = 0
    
    
    init(listeMots:[String], objectif: String) {
        listeReduiteMots = listeMots
        motATrouver = objectif
    }
 
    
    //A chaque fois que l'on présente un mot
    func nouvellePresentation()  {
        nombreDePresentations += 1
        
    }
    // Compien de présentations de mots ?
    func  getNumberPresentations() -> Int {
        return nombreDePresentations
    }
    
    // Mot attrappé ?
    func  isCatched() -> Bool {
        return motATrouver == motCourantAVoir
    }
    
    //Partie termnée ? Si on a trouvé le mot ou si on a présenté NOMBRE_ESSAIS_POSSIBLES mot
    func isTerminated() -> Bool {
        return isCatched() || nombreDePresentations >= NOMBRE_ESSAIS_POSSIBLES
    }
    
    // Uitiliaires d'accès aux données
    // Le mot qui doit être trouvé
    func getWordSearched() -> String {
        return motATrouver
    }
    // Le mot qui vient d'être vu
    func getWordViewed() -> String {
        return motCourantAVoir
    }
    // Tirer un mot au hasard dans la liste pour le présenter
    func setRandomWord() -> String {
        let objectif = Int(arc4random_uniform(UInt32(listeReduiteMots.count)))
        motCourantAVoir = listeReduiteMots[objectif]
        return motCourantAVoir
    }
    // Initialiser l'objectif
    func  setObjectif()->String  {
        motATrouver = setRandomWord()
        motCourantAVoir = ""
        return motATrouver
    }
    
}
