//
//  GestionFile.swift
//  catchIt
//
//  Created by patrick lanneau on 23/07/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import Foundation


class GestionFiles {
    
    //let KEY_JOUEUR = "nomJoueur"
    
    var serieCourante:[String] = []
    var niveauSerie: Int = 3
    var vitesseAffichageEclair:vitesseEclair = .lent
    
    var players:[Player] = []
    var currentPlayer: Player?
    var nameCurrentPlayer = ""
    
    
    
    init() {
        players = openFile()
        if players.count == 0 {
            currentPlayer = nil
        } else {
            recallPermanentDatas()
            if let curPlayer = searchPlayer(byName: nameCurrentPlayer) {
                currentPlayer = curPlayer
            }
        }
        
    }
    // ---------------------
    func setNiveauSerie(value:Int) {
        niveauSerie = value
    }
    
    func  getNiveau() -> Int {
        return niveauSerie
    }
    
    func setVitesse(v:vitesseEclair) {
        vitesseAffichageEclair = v
    }
    
    func getVitesse() -> vitesseEclair {
        return vitesseAffichageEclair
    }
    
    func addPlayer(player:Player)  {
        players.insert(player, at: 0)
        currentPlayer = player
        nameCurrentPlayer = player.nom
        saveFile(joueurs: players)
        savePermanentData()
    }
    
    func addPartie(part:Resultat, toPlayer:Player)  {
        toPlayer.ajoutPartie(res: part)
        saveFile(joueurs: players)
    }
    
    func removePartie(posPart:Int, fromPlayer:Player) {
        fromPlayer.removePartie(pos: posPart)
        saveFile(joueurs: players)
    }
    
    func searchPlayer(byName:String) -> Player? {
        var pos = -1
        for i in 0..<players.count{
            if players[i].nom == byName {
                pos = i
                return players[i]
            }
        }
        if pos > -1 {
            return players[pos]
        }
        return nil
    }
    
    //Gestion de partie
    // partieCourante est un cycle de partie : on dispose dans une partie
    // D'une liste de mots, d'un mot à trouver, et on gère les interactions et la boucle
    
    func nouvellePartie() -> Partie {
        var partie:Partie
        if serieCourante.count == 0 {
            serieCourante = openwordsList(longueur: getNiveau())
        }
        let listeReduiteMots = listeDeMots(longueur: NOMBRE_MOTS_AFFICHABLES)
        let objectif = Int(arc4random_uniform(UInt32(listeReduiteMots.count)))
        let motATrouver = listeReduiteMots[objectif]
        //let motCourantAVoir = ""
        partie = Partie(listeMots: listeReduiteMots, objectif: motATrouver)
        return partie
    }
    
    //Enregistrer les résultats d'une partie
    func saveScore(resultat: Resultat) {
        guard let current = currentPlayer else {return}
        if resultat.succes {
            current.incrementScore()
        }
        current.ajoutPartie(res: resultat)
        saveFile(joueurs: players)
    }
    
    // Récupére les données courantes dans userdefault
    func recallPermanentDatas() {
        if let nom = UserDefaults.standard.object(forKey: KEY_JOUEUR) {
            nameCurrentPlayer = nom as! String
        }
    }
    
    func savePermanentData(){
        UserDefaults.standard.set(nameCurrentPlayer, forKey: KEY_JOUEUR)
    }
    
    // Ouvrir le fichier JSON des joueurs
    // Le fichier s'appelle "memoire.json"
    // Renvoie un tableau de Players
    func openFile() -> [Player] {
        var recall:[Player] = []
        // Récupération depuis un fichier
        //let fileName = "listchronos"$
        var fileName = "memoire"
        
        let dir = try? FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask, appropriateFor: nil, create: true)
        // Si on trouve le directory, on lit
        if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("json") {
            // On récupère
            do {
                if  FileManager.default.fileExists(atPath: fileURL.path){
                    let data = try? FileManager.default.contents(atPath: fileURL.path)
                    let decoder = JSONDecoder()
                    if let mt = try? decoder.decode([Player].self, from: data!!){
                        //print("\(mt)")
                        recall = mt
                    }
                }
                
            } catch {
                print(NSLocalizedString("Failed reading from URL: \(fileURL), Error: ", comment: "Impossible de lire l'URL: \(fileURL), Erreur: "))
                recall = []
            }
        }
        //print("Sortie de recallIdent avec \(recall), ident = \(identConfig), \n, classes = \(listeClasses) \n")
        return recall
    }
    
    //Enregistrer le fichier JSON des joueurs
    // Le fichier s'appelle "memoire.json"
    // Enregistre un tableau de Players
    func saveFile(joueurs:[Player]) {
        // Save lesEvenements in userdefault
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(joueurs) {
            if let json = String(data: encoded, encoding: .utf8) {
                //print(json)
                // enregistrer dans un fichier
                //var prefix = inFile
                let fileName = "memoire"
                let dir = try? FileManager.default.url(for: .documentDirectory,
                                                       in: .userDomainMask, appropriateFor: nil, create: true)
                // Si on trouve le directory, on enregistre
                if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("json") {
                    do{
                        try json.write(to: fileURL, atomically: true, encoding: .utf8)
                    }catch {
                        print(NSLocalizedString("Writing error", comment: "erreur d'écriture"))
                    }
                    //print("saveChronologies fait : \(json)")
                }
            }
        }
    }
    
    //--------------------------
    // Récupérations des listes de mots de longueur L
    func openwordsList(longueur:Int) -> [String] {
        var result:[String] = []
        let nomFichier = "motsde\(longueur)"
        let filePath = Bundle.main.path(forResource: nomFichier, ofType: ".txt")
        let text = try? String(contentsOfFile: filePath!, encoding: String.Encoding.utf16)
        
        result = text!.components(separatedBy: "\n")
        serieCourante = result
        return result
    }
    
    
    // outils d'extraction depuis les fichiers
    // renvoie une liste le longiueur mots extraits de la série courante
    func listeDeMots(longueur:Int) -> [String] {
        // extrait longueur  mots de la serie courante
        var result : [String] = []
        if longueur >= serieCourante.count {
            result = serieCourante
            return result}
        if longueur < 1 {return result}
        
        
        for _ in 0..<longueur {
            var contained = false
            repeat {
                let unePlace = Int(arc4random_uniform(UInt32(serieCourante.count)))
                let unMot = serieCourante[unePlace]
                if  !result.contains(unMot) {
                    result.append(unMot)
                    contained = true
                }
            } while !contained
        }
        // Verif longueur de mot
        //print("niveau série : \(getNiveau()), longueur mot 1 : \(result[0].count), \(result[0]), \(result[1])")
        return result
    }
    //------------------------
    
}
