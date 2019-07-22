//
//  PlayViewController.swift
//  catchIt
//
//  Created by patrick lanneau on 20/07/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//
//
// Notes pour l'animation
//Pour lancer les animations : self.view.layoutIfNeeded()
//
// On prépare les animations, puis :
// UIView.animate(withDuration: 1, animations: {
//      self.view.layoutIfNeeded()
// })


import UIKit

import  AVFoundation

class PlayViewController: UIViewController, AVAudioPlayerDelegate {

    // la pile centrale pour l'incliner selon le sens
    
    // Le modele central passé par segue
    
    var gestFile:GestionFiles?
    
    
    @IBOutlet weak var cible: CibleView!
    
    @IBOutlet weak var ui_invite: UILabel!
    @IBOutlet weak var ui_lancement: UILabel!
    
    @IBOutlet weak var pileG: UIStackView!
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
        
        //print("play : largeur : \(self.view.frame.width), hauteur =  \(self.view.frame.height)")
        //print("cible dans play : largeur : \(cible.frame.width), hauteur =  \(cible.frame.height)")
        //let largeur = min(self.view.frame.width, self.view.frame.height)
        //cible.frame.size = CGSize(width: largeur, height: largeur)
        if UIDevice.current.orientation.isPortrait {
            pileG.axis = .vertical
        } else {
            pileG.axis = .horizontal
        }
        
        cible.miseEnPlace()
        
        let slargeur = self.view.frame.width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right
        let shauteur = self.view.frame.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom
        //let largeur = self.view.safeAreaLayoutGuide.width
        //let hauteur = self.pileG.frame.size.height
        //let tailleCible = min(largeur, hauteur)
        let sizeTailleCible = min(slargeur, shauteur)
        self.cible.frame.size = CGSize(width: sizeTailleCible, height: sizeTailleCible)
        //self.cible.imageView.frame = CGRect(x: 0, y: 0, width: sizeTailleCible, height: sizeTailleCible)
        cible.miseAJourTaille()
        //cible.miseEnPlace()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.actionCible))
        cible.addGestureRecognizer(tapGesture)
        cible.isUserInteractionEnabled = true
        
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let mod = gestFile, let courant = mod.currentPlayer {
            ui_invite.text = NSLocalizedString("Catch the bumper, ", comment: "Tape le Bumper, ") + "\(courant.nom) !"
        }
        
        // taille de la cible
        if UIDevice.current.orientation.isPortrait {
            pileG.axis = .vertical
        } else {
            pileG.axis = .horizontal
        }
        let slargeur = self.view.frame.width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right
        let shauteur = self.view.frame.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom
        //let largeur = self.pileG.frame.size.width
        //let hauteur = self.pileG.frame.size.height
        //let tailleCible = min(largeur, hauteur)
        let sizeTailleCible = min(slargeur, shauteur)
        self.cible.frame.size = CGSize(width: sizeTailleCible, height: sizeTailleCible)
        //self.cible.imageView.frame = CGRect(x: 0, y: 0, width: sizeTailleCible, height: sizeTailleCible)
        cible.miseAJourTaille()
        
        self.navigationController?.navigationBar.titleTextAttributes = [.font: FONT_DE_BASE as Any, .foregroundColor: ROUGE]
        //self.navigationController?.navigationBar.tintColor = GRIS_TRES_CLAIR
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Réglages initiaux du modèle
        
        // Affichage des labels
        affichageLancerChasse()
        // taille de la cible
        if UIDevice.current.orientation.isPortrait {
            pileG.axis = .vertical
        } else {
            pileG.axis = .horizontal
        }
        
        //cible.miseEnPlace()
        
        let slargeur = self.view.frame.width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right
        let shauteur = self.view.frame.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom
        //let largeur = self.pileG.frame.size.width
        //let hauteur = self.pileG.frame.size.height
        //let tailleCible = min(largeur, hauteur)
        let sizeTailleCible = min(slargeur, shauteur)
        self.cible.frame.size = CGSize(width: sizeTailleCible, height: sizeTailleCible)
        //self.cible.imageView.frame = CGRect(x: 0, y: 0, width: sizeTailleCible, height: sizeTailleCible)
        cible.miseAJourTaille()
        //-------
        
        //cible.miseEnPlace()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isPortrait {
            pileG.axis = .vertical
        } else {
            pileG.axis = .horizontal
        }
        // après la rotation
        coordinator.animate(alongsideTransition: { (_) in
            //let largeur = min(self.view.frame.width, self.view.frame.height)
            //let largeur = view.safeAreaInsets.
            let slargeur = size.width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right
            let shauteur = size.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom
            //let largeur = self.pileG.frame.size.width
            //let hauteur = self.pileG.frame.size.height
            //let tailleCible = min(largeur, hauteur)
            let sizeTailleCible = min(slargeur, shauteur)
            self.cible.frame.size = CGSize(width: sizeTailleCible, height: sizeTailleCible)
            //self.cible.imageView.frame = CGRect(x: 0, y: 0, width: sizeTailleCible, height: sizeTailleCible)
            self.cible.miseAJourTaille()
            //print("Size = \(size.width) de large")
            //print("Pile : \(self.pileG.bounds), cible : \(sizeTailleCible)")
        }, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        timer1.invalidate()
        //On initialise
        nombreDeTaps = -1
        repetition = 0
        apparitions = 0
        // Affichage des labels
        affichageChasseEnCours()
        
        if let gf = gestFile {
            modele = gf.nouvellePartie()
            cible.encocheFleche()
            //let lacible = #imageLiteral(resourceName: "cible").size
            recherche = (modele?.setObjectif())!
        }
        //cible.partieGagnee(nombreDeTaps: 3, apparitions: 3)
        let titre = NSLocalizedString("Warning !", comment: "Attention")
        let message = NSLocalizedString("Catch this word", comment: "Chasser le mot ci-dessous") + "\n \n\(recherche)"
        cible.afficheMessage(titre: titre, messge: message)
        
        // on donne l'instruction de lancement
        ui_lancement.isHidden = false
        cycleDeJeuEnclanche = true
        
    }
    
    //-------------------------
    // action lors d'une tape sur la cible
    
    @objc func actionCible(gesture: UIGestureRecognizer){
        
        if gesture.view as? CibleView != nil {
            // Au cas où la flèche serait là, on la cache
            cible.nettoyage()
            if cycleDeJeuEnclanche {
                if nombreDeTaps < 0 {
                    ui_lancement.isHidden = true
                    presenterMot()
                }
                nombreDeTaps += 1
                //ui_lancement.isHidden = true
                if (modele?.isCatched())! {
                    timer1.invalidate()
                    partieGagnee()
                    cycleDeJeuEnclanche = false
                }
            }
            
            
        }
        
    }
    
    func presenterMot()  {
        if let leModele = modele {
            let aAfficher = leModele.setRandomWord()
            //print("mot cherché : \(recherche)")
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
            var vitesse:vitesseEclair = .lent
            if let gf = gestFile {
                vitesse = gf.getVitesse()
            }
            //let vitesse = gestFile.
            cible.afficheMouche(titre: motAffiche)
            _ = Timer.scheduledTimer(timeInterval: vitesse.rawValue, target: self, selector: #selector(self.afficheEclair), userInfo: "compte à rebour lancé...", repeats: false)
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
    /*
    @objc func testeMot(){
        if let leModele = modele {
            let test = leModele.getWordViewed() == leModele.getWordSearched()
            // On choisit le nouveau mot à afficher
            _ = leModele.setRandomWord()
        }
        
    }
    */
    func partieGagnee() {
        bilan(avecSucces: true)
        cible.partieGagnee(nombreDeTaps: nombreDeTaps, apparitions: apparitions)
        /*
        cible.encocheFleche()
        var message = "Avec juste \(nombreDeTaps) tap"
        if nombreDeTaps > 1 {
            message += "s"
        }
        message += "\nLe mot est apparu \(apparitions) fois"
        cible.afficheMessage(titre: "Trouvé !", messge: message)
        //print(message)
        cible.decocheFleche()
 */
    }
    func partiePerdue()  {
        bilan(avecSucces: false)
        cible.partiePerdue(nombreDeTaps: nombreDeTaps, apparitions: apparitions)
        /*
        cible.afficheMessage(titre: "Perdu !", messge: "tu as essayé \(nombreDeTaps) taps, mais tu as raté le mot... apparu \(apparitions) fois")
 */
    }
 
    func bilan (avecSucces:Bool)  {
        guard let niveau = gestFile?.getNiveau() else {return}
        guard let motcible = modele?.getWordSearched() else {
            return
        }
        affichageLancerChasse()
        let resultat = Resultat(niveau: niveau, motCible: motcible, succes: avecSucces, taps: nombreDeTaps)
        gestFile?.saveScore(resultat: resultat)
    }
    
    // Gestion des affichages des labels
    func affichageLancerChasse(){
        ui_invite.text = NSLocalizedString("Catch le Bumper...", comment: "tape le Bumper...")
        ui_lancement.text = NSLocalizedString("to hunt the word...", comment: "pour lancer une chasse")
    }
    
    func affichageChasseEnCours()  {
        ui_invite.text = NSLocalizedString("Catch le target...", comment: "Tape la cible...")
        ui_lancement.text = NSLocalizedString("when you see the word...", comment: "quand tu vois le gibier")
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
