//
//  ViewController.swift
//  catchIt
//
//  Created by patrick lanneau on 19/07/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController , AVAudioPlayerDelegate {

    // la pile centrale
    @IBOutlet weak var centralStack: UIStackView!
    @IBOutlet weak var commandStack: UIStackView!
    
    // Interface
    
    @IBOutlet weak var leverLabel: UILabel!
    @IBOutlet weak var levelSlider: UISlider!
    
    // Variables d"'interface
    var level = 3
    var speed : vitesseEclair = .moyen
    
    
    
    @IBOutlet weak var cible: UIImageView!
    
    //@IBOutlet weak var texteAReconnaitre: UITextField!
    //@IBOutlet weak var fleche: UIImageView!
    
    //var fleche:UIImage = UIImage(named: "Arrow")!
    //var vueFleche : UIImageView?
    
    var messageBox: MessageView?
    var laMouche: MoucheView?
    
    private var soundPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation.isPortrait {
            centralStack.axis = .vertical
            commandStack.axis = .horizontal
        } else {
            centralStack.axis = .horizontal
            commandStack.axis = .vertical
        }
        // Do any additional setup after loading the view.
        //On crée l'image flèche et on la positionne
        //fleche.draw(in: CGRect(x: <#T##Int#>, y: <#T##Int#>, width: <#T##Int#>, height: <#T##Int#>))
        //fleche.isHidden = true
        
        // On prépare la boite message
        
        messageBox = MessageView(frame: CGRect(x: 0, y: 0, width: cible.frame.width / 2, height: cible.frame.height / 2))
        let xMess = cible.frame.origin.x + (cible.frame.size.width / 2)
        let yMess = cible.frame.origin.y + (cible.frame.size.height / 2)
        messageBox?.center = CGPoint(x: xMess, y: yMess)
        
        //print("--->   Message box : \(messageBox!.center)")
        messageBox?.miseEnPlace()
        messageBox?.isHidden = true
        guard messageBox != nil else {return}
        view.addSubview(messageBox!)
        
        // On perépare la mouche
        //let coteCible = cible.frame.width
        laMouche = MoucheView(frame: CGRect(x: 0, y: 0, width: 130, height: 80))
        cible.addSubview(laMouche!)
        // Test de la mouche
        laMouche?.setText(value: "substantif")
        let moucheCX:CGFloat = 170.0
        let mouchCY:CGFloat = 200.0
        laMouche!.center.x = moucheCX
        laMouche!.center.y = mouchCY
        laMouche?.isHidden = true
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait {
            centralStack.axis = .vertical
            commandStack.axis = .horizontal
        } else {
            centralStack.axis = .horizontal
            commandStack.axis = .vertical
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation.isPortrait {
            centralStack.axis = .vertical
             commandStack.axis = .horizontal
        } else {
            centralStack.axis = .horizontal
            commandStack.axis = .vertical
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Actions d'interface
    @IBAction func sliderAction(_ sender: UISlider) {
        level = Int(sender.value + 0.5)
        sender.setValue(Float(level), animated: false)
        leverLabel.text = "Mots de longueur : \(level)"
    }
    
    
    @IBAction func startAction(_ sender: UIButton) {
       
        jouerSon("Arrow+3")
        
        //cible.isHidden = true
        //view.bringSubview(toFront: fleche!)
        messageBox?.setMessage(titre: "Attention", complement: "le mot que tu vas devoir chasser va apparaitre 1 seconde!")
        messageBox?.isHidden = false
        UIView.transition(with: messageBox!, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            
        }, completion: nil)
        
        // On affiche très vite
        laMouche?.apparaitDurant(second: 1)
        
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

