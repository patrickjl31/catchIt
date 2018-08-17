//
//  GestionViewController.swift
//  catchIt
//
//  Created by patrick lanneau on 19/07/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

class GestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
   

    // paramètres globaux
    var baseJeu:GestionFiles = GestionFiles()
    
    // Gestion du jeu
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var levelSlider: UISlider!
    
    // Gestion des joueurs
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var labelNamePlayer: UILabel!
    
    @IBOutlet weak var tablePlayers: UITableView!
    
    var namePlayer = ""
    var speed:vitesseEclair = .lent
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Ouvrir la base modele
        //baseJeu = GestionFiles()
        
        // La table
        tablePlayers.delegate = self
        tablePlayers.dataSource = self
        // Le nom
        nameField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    //Gestion des paramètres de jeu
    @IBAction func levelSliderAction(_ sender: UISlider) {
        let level = Int(sender.value + 0.5)
        sender.setValue(Float(level), animated: true)
        levelLabel.text = "Level : " + "\(level)"
    }
    @IBAction func segmentedSpeedAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            speed = .lent
            speedLabel.text = "Speed : \(speed)"
        case 1:
            speed = .moyen
            speedLabel.text = "Speed : \(speed)"
        case 2:
            speed = .rapide
            speedLabel.text = "Speed : \(speed)"
        default:
            speed = .moyen
            speedLabel.text = "Speed : \(speed)"
        }
    }
    
    
    
    // Gestion des joueurs
    func validationNamePlayer(player:String) -> Bool {
        var res = false
        if let player = baseJeu.searchPlayer(byName: player) {
            baseJeu.currentPlayer = player
            tablePlayers.reloadData()
            res = true
        } else {
            let joueur = Player(nom: player)
            baseJeu.addPlayer(player: joueur)
            tablePlayers.reloadData()
            baseJeu.currentPlayer = joueur
            res = true
        }
        
        return res
    }
    
    // Le textfield du joueur courant
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField,
            let name = textField.text {
            miseAJourChampNom(nom: name)
            //namePlayer = name
            //labelNamePlayer.text = "\(namePlayer), c'est toi qui joue..."
            let val = validationNamePlayer(player: name)
            //print("retour validation : \(val), la table a \(baseJeu.players.count) élems")
        }
        return true
    }
    
    func miseAJourChampNom(nom:String)  {
        namePlayer = nom
        labelNamePlayer.text = "\(namePlayer), c'est toi qui joue..."
        nameField.text = nom
    }
    
    // La table des joueurs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return baseJeu.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tablePlayers {
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_NOMS, for: indexPath)
        let joueur = baseJeu.players[indexPath.row]
        cell.textLabel?.text = joueur.nom
        cell.detailTextLabel?.text = String(joueur.score)
        //print("\(joueur.nom)")
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let player = baseJeu.players[indexPath.row]
        miseAJourChampNom(nom: player.nom)
        validationNamePlayer(player: player.nom)
        return indexPath
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
