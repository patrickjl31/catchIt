//
//  CibleView.swift
//  catchIt
//
//  Created by patrick lanneau on 27/07/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit
import  AVFoundation

class CibleView: UIView, AVAudioPlayerDelegate {

    var fleche: UIImageView
    var laMouche:MoucheView
    var messageBox:MessageView
    
    // -------service ----
    private var soundPlayer: AVAudioPlayer?
    
    override init(frame: CGRect) {
        //On initialise les images objets
        fleche = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        // On prépare la boite message
        messageBox = MessageView(frame: CGRect(x: 0, y: 0, width: frame.width / 2, height: frame.height / 2))
        // la mouche
        laMouche = MoucheView(frame: CGRect(x: 0, y: 0, width: 130, height: 80))
        super.init(frame: frame)
        
       
        miseEnPlace()
    }
    required init?(coder aDecoder: NSCoder) {
        //On initialise les images objets
        fleche = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        // On prépare la boite message
        messageBox = MessageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        // la mouche
        laMouche = MoucheView(frame: CGRect(x: 0, y: 0, width: 130, height: 80))
        
        super.init(coder: aDecoder)
        messageBox.frame.size = CGSize(width: frame.width / 2, height: frame.height / 2)
       //miseEnPlace()
        
    }
    
    func miseEnPlace()  {
        
        //On initialise les images objets
        //fleche = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 160))
        
        // On prépare la boite message
        //messageBox = MessageView(frame: CGRect(x: 0, y: 0, width: frame.wi@objc dth / 2, height: frame.height / 2))
        // la mouche
        //laMouche = MoucheView(frame: CGRect(x: 0, y: 0, width: 130, height: 80))
        
        
        let backImage = UIImage(named: "cible")
        let large = self.frame.size.width
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: large, height: large))
        //print("cible : largeur : \(self.frame.width), hauteur =  \(self.frame.height)")
        //print("vue : largeur : \(self.bounds.width), hauteur =  \(self.bounds.height)")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        //imageView.contentMode = .center //UIViewContentMode.center
        imageView.image = backImage
        addSubview(imageView)
        
        //messageBox
        
        messageBox.frame.size = CGSize(width: self.frame.width / 2, height: self.frame.height / 2)
        // on la centre
        messageBox.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        messageBox.miseEnPlace()
        messageBox.isHidden = true
        addSubview(messageBox)
        
        //laMouche
        //laMouche = MoucheView(frame: CGRect(x: 0, y: 0, width: 130, height: 80))
        laMouche.frame.size = CGSize(width: 130, height: 80)
        laMouche.miseEnPlace()
        laMouche.isHidden = true
        addSubview(laMouche
        )
        
        //fleche = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 160))
        fleche.frame.origin = CGPoint(x: -200, y: -200)
        fleche.image = UIImage(named: "Arrow")
        fleche.contentMode = .scaleToFill
        fleche.clipsToBounds = false
        fleche.isHidden = true
        addSubview(fleche)
        
    }
    
   
    func encocheFleche()  {
        fleche.frame.origin = CGPoint(x: -200, y: -200)
        fleche.isHidden = true
    }
    
    func  decocheFleche() {
        fleche.isHidden = false
        jouerSon("Arrow+3")
        //print("décoche")
       
        UIView.animate(withDuration: 0.5) {
            let centreX = self.frame.size.width / 2
            let centreY = self.frame.size.height / 2
            self.fleche.frame.origin.x = centreX - self.fleche.frame.height
            self.fleche.frame.origin.y = centreY - self.fleche.frame.width
            //print("centre: \(centreX) ou bien \(centreY) pour taille \(self.frame.size), flèche cachée : \(self.fleche.isHidden)")
        }
 
    }
    
    func afficheMessage(titre:String, messge:String) {
        messageBox.setMessage(titre: titre, complement: messge)
        messageBox.isHidden = false
        //UIView.transition(with: messageBox, duration: 0.5, options: .transitionFlipFromLeft, animations: {}, completion: nil)
        UIView.transition(with: messageBox, duration: 0.5, options: .transitionFlipFromLeft, animations: {self.messageBox.isHidden = false}, completion: nil)
        
    }
    // On cache la boite message
    func hideMessageBox() {
        messageBox.isHidden = true
    }
    // On cache tout sauf la cible
    func nettoyage()  {
        encocheFleche()
        hideMessageBox()
        cacheMouche()
    }
    
    // Affiche la mouche avec son mot quelque part sur la cible
    func afficheMouche(titre:String)  {
        laMouche.setText(value: titre)
        laMouche.center = positionAleatoire(objet: laMouche.frame)
        laMouche.isHidden = false
        
    }
    
    func cacheMouche() {
        laMouche.isHidden = true
    }
    
    // Propose un point pour positionner le centre de la mouche sur la cible
    //La mouche ne dépasse pas du cadre
    func positionAleatoire(objet: CGRect) -> CGPoint {
        let xMin = objet.width / 2
        let yMin = objet.height / 2
        let largeurUtile = self.frame.size.width - objet.width
        let hauteurUtile = self.frame.size.height - objet.height
        let xAlea = CGFloat( arc4random_uniform(UInt32(largeurUtile))) + xMin
        let yAlea = CGFloat( arc4random_uniform(UInt32(hauteurUtile))) + yMin
        return CGPoint(x: xAlea, y: yAlea)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // Affichage des résultats
    func partieGagnee(nombreDeTaps: Int, apparitions: Int)  {
        encocheFleche()
        //print("va décocher")
        decocheFleche()
        var message = "Avec juste \(nombreDeTaps) tap"
        if nombreDeTaps > 1 {
            message += "s"
        }
        message += "\nLe mot est apparu \(apparitions) fois"
        afficheMessage(titre: "Trouvé !!!", messge: message)
    
    }
    
    func partiePerdue(nombreDeTaps: Int, apparitions: Int)  {
        var message = "Tu as essayé \(nombreDeTaps) fois"
        message += "\nLe mot est apparu \(apparitions) fois"
        afficheMessage(titre: "Perdu !", messge: message)
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
