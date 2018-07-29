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
    var listeCouranteMots:[String] = []
    var level:Int = 3
    
    // cette classe gère les enregistrements et les utilisateurs
    let files:GestionFiles = GestionFiles()
    
    // Varialbes de service
    // nombreDePresentations est le nombre de mots présentés dans la partie
    var nombreDePresentations = 0
    
    init() {
        
    }
    
    func setLevel(niveau:Int)  {
        level = niveau
        files.setNiveauSerie(value: niveau)
        listeCouranteMots = files.openwordsList(longueur: niveau)
    }
    
    
    func nouvellePartie()  {
        if listeCouranteMots.count == 0 {
            listeCouranteMots = files.openwordsList(longueur: level)
        }
        //Préparer une liste de mots à afficher et en extraire le mot à trouver
        listeCouranteMots = files.listeDeMots(longueur: NOMBRE_MOTS_AFFICHABLES)
        let objectif = Int(arc4random_uniform(UInt32(listeCouranteMots.count)))
        motATrouver = listeCouranteMots[objectif]
        
    }
    
    func nouvellePresentation()  {
        nombreDePresentations += 1
        
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
        let objectif = Int(arc4random_uniform(UInt32(listeCouranteMots.count)))
        motCourantAVoir = listeCouranteMots[objectif]
        return motCourantAVoir
    }
    
}
