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

    @IBOutlet weak var cible: CibleView!
    
    
    //@IBOutlet weak var texteAReconnaitre: UITextField!
   
    
    //var fleche:UIImage = UIImage(named: "Arrow")!
    //var vueFleche : UIImageView?
    
   
    
    private var soundPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //cible.miseEnPlace()
        

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        //let f = fleche.frame
        //let lacible = #imageLiteral(resourceName: "cible").size
        cible.encocheFleche()
        cible.afficheMessage(titre: "Attention", messge: "vous allez devoir chasser le mot qui est affiché au tableau ci-dessous")
        cible.decocheFleche()
        /*
        //cible.isHidden = true
        view.bringSubview(toFront: fleche!)
        messageBox?.setMessage(titre: "Attention", complement: "le mot que tu vas devoir chasser va apparaitre 1 seconde!")
        messageBox?.isHidden = false
        UIView.transition(with: messageBox!, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            
        }, completion: nil)
        
        // On affiche très vite
        laMouche?.apparaitDurant(second: 1)
        */
    }
    
   
    // Mouvement de la flèche
    func initPosFleche(aDeplacer: UIImageView, versCible: CGRect)-> CGPoint  {
        // On positionne la flèche sur le cdoin haut gauche de la cible
        let x = versCible.minX - aDeplacer.frame.width
        let y = versCible.minY - aDeplacer.frame.height
        return CGPoint(x: x, y: y)
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
