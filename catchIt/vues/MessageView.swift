//
//  MessageView.swift
//  catchIt
//
//  Created by patrick lanneau on 25/07/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

class MessageView: UIView {

    var titre: UILabel?
    var message: UILabel?
    
    var timer:Timer = Timer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func miseEnPlace() {
        // On repère les dimensions de la boite
        let tailleCote = self.bounds.size.height
        // On dessine
        self.layer.cornerRadius = self.frame.width / 2
        //self.backgroundColor = GRIS_TRES_FONCE
        
        let backImage = UIImage(named: "blank_blackboard")
        let imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = self.frame.width / 2
        imageView.clipsToBounds = true
        imageView.image = backImage
        addSubview(imageView)
        
        
        titre = UILabel(frame: CGRect(x: 10, y: (tailleCote / 4) - 15, width: frame.width - 30, height: 30))
        titre?.textAlignment = .center
        titre?.font = FONT_TITRE
        titre?.textColor = GRIS_TRES_CLAIR
        guard titre != nil else {return}
        addSubview(titre!)
        
        message = UILabel(frame: CGRect(x: 10, y: (tailleCote / 2) - 20, width: frame.width - 20, height: 80))
        message?.textAlignment = .center
        message?.numberOfLines = 0
        message?.font = FONT_DE_BASE
        message?.textColor = GRIS_TRES_CLAIR
        guard message != nil else {return}
        addSubview(message!)
        
        // Ajout de la sensibilité au touché pour cacher la boite
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.checkAction(sender:)))
        self.addGestureRecognizer(gesture)
        
    }
    func setMessage(titre:String, complement : String)  {
        self.titre?.text = titre
        self.message?.text = complement
    }
    
    @objc func checkAction(sender: UITapGestureRecognizer){
        self.isHidden = true
    }
    
    // Fonctions d'apparition
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
