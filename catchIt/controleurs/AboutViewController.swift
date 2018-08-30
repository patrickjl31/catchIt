//
//  AboutViewController.swift
//  catchIt
//
//  Created by patrick lanneau on 26/08/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var ui_titre: UILabel!
    
    @IBOutlet weak var ui_texte: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ui_titre.text = "Catch'It"
        
        let leTexte = """
Catch’It est un jeu éducatif destiné à améliorer les capacités de lecture rapide d’un lecteur.
Pour jouer, l’utilisateur doit s’identifier en tapant son nom ou en le choisissant dans la liste des joueurs inscrits. Il peut alors entrer dans le jeu en ouvrant le logo Catch’It.

Pour jouer une partie, tapez le Bumper !!! Catch’It propose d’attraper un mot qu’il présente puis, il montre toutes les secondes un mot de même longueur pendant un temps très court. Lorsque vous voyez le mot recherché, tapez la cible !!!

Catch’it mémorise votre partie (le mot cherché, en combien d’essais, à quel moment) ainsi, vous pourrez suivre à tout moment vos progrès.

Catch’It s’inspire d’exercices de lecture rapide, en particuliers ceux proposés par l’AFL (Association Française pour la Lecture) et les travaux de Jean Foucambert et Evelyne Charmeux (chercheurs à l’INRP).
"""
        ui_texte.text = leTexte
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionOK(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
