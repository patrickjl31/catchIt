//
//  MoucheView.swift
//  catchIt
//
//  Created by patrick lanneau on 26/07/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

class MoucheView: UIView {

    var texteLabel = UILabel()
    
    // Pour régler les temps d'apparition
    var timer:Timer = Timer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        miseEnPlace()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func miseEnPlace()  {
        let tailleCoteW = self.bounds.size.width
        let tailleCoteH = self.bounds.size.height
        
        self.layer.cornerRadius = self.frame.width / 3
        //self.backgroundColor = GRIS_TRES_FONCE
        // On met une image de fond
        let backImage = UIImage(named: "blank_blackboard")
        let imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = self.frame.width / 3
        imageView.clipsToBounds = true
        imageView.image = backImage
        addSubview(imageView)
        
        //texteLabel = UILabel(frame: CGRect(x: 5, y: (tailleCoteH / 2) - 20 , width: tailleCoteW - 10, height: 30))
        texteLabel.frame = CGRect(x: 5, y: (tailleCoteH / 2) - 20 , width: tailleCoteW - 10, height: 30)
        texteLabel.minimumScaleFactor = 14.0
        texteLabel.adjustsFontSizeToFitWidth = true
        texteLabel.textAlignment = .center
        texteLabel.font = FONT_PETIT
        texteLabel.textColor = GRIS_TRES_CLAIR
        
        addSubview(texteLabel)
        
    }
    
    func setText(value: String) {
        texteLabel.minimumScaleFactor = 14.0
        texteLabel.adjustsFontSizeToFitWidth = true
        texteLabel.text = value
    }
    
    func setPositionCenter(x:CGFloat, y: CGFloat)  {
        self.center.x = x
        self.center.y = y
    }
    
    // Apparition, disparition
    func apparaitDurant(second:TimeInterval)  {
        if self.isHidden {
            self.isHidden = false
            timer = Timer.scheduledTimer(timeInterval: second, target: self, selector: #selector(cacheMoi), userInfo: "apparition", repeats: false)
        }
    }
    
    @objc func cacheMoi(){
        self.isHidden = true
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
