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
       miseEnPlace()
        
    }
    
    func miseEnPlace()  {
        
        //On initialise les images objets
        //fleche = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 160))
        
        // On prépare la boite message
        //messageBox = MessageView(frame: CGRect(x: 0, y: 0, width: frame.width / 2, height: frame.height / 2))
        // la mouche
        //laMouche = MoucheView(frame: CGRect(x: 0, y: 0, width: 130, height: 80))
        
        
        let backImage = UIImage(named: "cible")
        let imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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
        //fleche = UIImageView(frame: CGRect(x: -100, y: -100, width: 200, height: 160))
        //fleche = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 160))
        fleche.frame.origin = CGPoint(x: -200, y: -200)
        fleche.image = UIImage(named: "Arrow")
        fleche.contentMode = .scaleToFill
        fleche.clipsToBounds = false
        fleche.isHidden = true
        addSubview(fleche)
        
    }
    
    func encocheFleche()  {
        fleche.frame.origin = CGPoint(x: -200, y: -2100)
        fleche.isHidden = true
    }
    
    func  decocheFleche() {
        fleche.isHidden = false
        UIView.animate(withDuration: 1) {
            let centreX = self.frame.size.width / 2
            let centreY = self.frame.size.height / 2
            self.fleche.frame.origin.x = centreX - self.fleche.frame.height
            self.fleche.frame.origin.y = centreY - self.fleche.frame.width
            print("centre: \(centreX) ou bien \(centreY) pour taille \(self.frame.size)")
        }
    }
    
    func afficheMessage(titre:String, messge:String) {
        messageBox.setMessage(titre: titre, complement: messge)
        messageBox.isHidden = false
        UIView.transition(with: messageBox, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            
        }, completion: nil)
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
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
