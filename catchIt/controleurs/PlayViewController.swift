//
//  PlayViewController.swift
//  catchIt
//
//  Created by patrick lanneau on 20/07/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

import  AVFoundation

class PlayViewController: UIViewController, AVAudioPlayerDelegate {

    // la pile centrale pour l'incliner selon le sens
    
    // Le modele central passé par segue
    
    var gestFile:GestionFiles?
    
    @IBOutlet weak var cible: CibleView!
    
    
    //@IBOutlet weak var texteAReconnaitre: UITextField!
   
    
    //var fleche:UIImage = UIImage(named: "Arrow")!
    //var vueFleche : UIImageView?
    
    // variables de service
    var nombreDeTaps = -1
    var niveau : vitesseEclair = .lent
    var recherche = ""
    var cycleDeJeuEnclanche = false
    
    // Pour les test de boucle
    var repetition = 0
    // On compte le nombre d'apparitions du mot à chercher
    var apparitions = 0
    
    //timers
    private var timer1 = Timer()
    
    // Le modèle
    
    var modele:Partie?
   
    
    private var soundPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //cible.miseEnPlace()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.actionCible))
        cible.addGestureRecognizer(tapGesture)
        cible.isUserInteractionEnabled = true
        
        // Réglages initiaux du modèle
        if let gf = gestFile {
            modele = gf.nouvellePartie()
            //modele.setLevel(niveau: 4)
            gf.setNiveauSerie(value: 4)
        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        //On initialise
        nombreDeTaps = -1
        repetition = 0
        apparitions = 0
        if let gf = gestFile {
            modele = gf.nouvellePartie()
            cible.encocheFleche()
            //let lacible = #imageLiteral(resourceName: "cible").size
            recherche = (modele?.setObjectif())!
        }
        
        cible.afficheMessage(titre: "Attention", messge: "Chasser le mot ci-dessous : \n \n\(recherche)")
        cycleDeJeuEnclanche = true
        
    }
    
    //-------------------------
    // action lors d'une tape sur la cible
    
    @objc func actionCible(gesture: UIGestureRecognizer){
        if gesture.view as? CibleView != nil {
            if cycleDeJeuEnclanche {
                if nombreDeTaps < 0 {
                    presenterMot()
                }
                nombreDeTaps += 1
                if (modele?.isCatched())! {
                    timer1.invalidate()
                    partieGagnee()
                    cycleDeJeuEnclanche = false
                }
            }
            // Au cas où la flèche serait là, on la cache
            cible.nettoyage()
            
        }
        
    }
    
    func presenterMot()  {
        if let leModele = modele {
            let aAfficher = leModele.setRandomWord()
            print("mot cherché : \(recherche)")
            cycleVolMouche(titre: aAfficher)
        }
        
        /*
        if repetition < 10 {
            // On affiche mouche, on attend intervalle, on le cache
            cycleVolMouche(titre: aAfficher)
            repetition += 1
            
        }
        */
    }
    
    func cycleVolMouche(titre:String)  {
        cible.cacheMouche()
        //var timer = Timer()
        timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.eclairMouche), userInfo: "compte à rebour lancé...", repeats: true)
    }
    
    @objc func eclairMouche() {
        //cible.cacheMouche()
        //var timer = Timer()
        repetition += 1
        if let mod = modele{
            let motAffiche = mod.setRandomWord()
            if motAffiche == recherche{
                apparitions += 1
            }
            cible.afficheMouche(titre: motAffiche)
            let timer = Timer.scheduledTimer(timeInterval: vitesseEclair.lent.rawValue, target: self, selector: #selector(self.afficheEclair), userInfo: "compte à rebour lancé...", repeats: false)
            if repetition > NOMBRE_ESSAIS_POSSIBLES {
                timer1.invalidate()
                partiePerdue()
            }
        }
        
    }
    
    @objc func afficheEclair(){
        cible.cacheMouche()
    }
    
    @objc func finAttente(){
        presenterMot()
    }
    @objc func testeMot(){
        if let leModele = modele {
            let test = leModele.getWordViewed() == leModele.getWordSearched()
            // On choisit le nouveau mot à afficher
            leModele.setRandomWord()
        }
        
    }
    
    func partieGagnee() {
        cible.encocheFleche()
        cible.afficheMessage(titre: "Trouvé !", messge: "Avec juste \(nombreDeTaps) taps\nLmot est apparu \(apparitions) fois")
        cible.decocheFleche()
    }
    func partiePerdue()  {
        cible.afficheMessage(titre: "Perdu !", messge: "tu as essayé \(nombreDeTaps) taps, mais tu as raté le mot... apparu \(apparitions) fois")
    }
 
    

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // ----------------
    // récupérer un tableau de mots de longueur n
    func tableauMotsDe(longueur:Int) -> [String] {
        var result:[String] = []
        if longueur > 2, longueur < 13 {
            let nomFichier = "motsde\(longueur)"
            let filePath = Bundle.main.path(forResource: nomFichier, ofType: ".txt")
            let text = try? String(contentsOfFile: filePath!, encoding: String.Encoding.utf16)
            
            result = text!.components(separatedBy: "\n")
        }
        return result
        
    }

    //MARK Le son
    // jouer un son
    func jouerSon (_ nom : String) {
        //var erreur : NSError?
        
        guard let ficURL = Bundle.main.url(forResource: nom, withExtension: "mp3") else {return}
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            soundPlayer = try AVAudioPlayer(contentsOf: ficURL, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = soundPlayer else { return }
            
            player.play()

            
        }catch let error {
            print(error.localizedDescription)
        }
        
        
       
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
    }
    
    
}
