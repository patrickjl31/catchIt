//
//  GestionViewController.swift
//  catchIt
//
//  Created by patrick lanneau on 19/07/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

class GestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate {
   

    // paramètres globaux
    var baseJeu:GestionFiles = GestionFiles()
    
    // Gestion du jeu
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var levelSlider: UISlider!
    @IBOutlet weak var objectCatchIt: UIImageView!
    @IBOutlet weak var segmentedSpeed: UISegmentedControl!
    
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
        
        //les réglages par défaut
        gestionAffichageParametres()
        
        // L'activation de l'image catch'It
        let tap = UITapGestureRecognizer(target: self, action: #selector(toCatchIt(_:)))
        tap.delegate = self
        objectCatchIt.addGestureRecognizer(tap)
        objectCatchIt.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = [.font: FONT_TITRE as Any, .foregroundColor: GRIS_TRES_CLAIR]
        self.navigationController?.navigationBar.tintColor = GRIS_TRES_CLAIR
        self.navigationController?.navigationBar.barTintColor = GRIS_TRES_FONCE
        
        //le bouton
        /*
        let item = UIButton(type: .infoLight)
        let baritem = UIBarButtonItem(customView: item)
        baritem.action = "infoButtonAction"
        //let item = UIBarButtonItem(image: UIImage(named: "infoImage.png"), style: .plain, target: self, action: #selector(infoButtonAction))
        //let item = UIBarButtonItem(image: bItem, style: .plain, target: self, action: #selector(infoButtonAction))
        self.navigationItem.rightBarButtonItem = baritem
 */
        //self.navigationItem.rightBarButtonItem?.image = UIImage(named: "blueinfo84")
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named: "blueinfo28"), for: .normal)
        button.addTarget(self, action: #selector(infoButtonAction), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        //translatesAutoresizingMaskIntoConstraints as false
        //button.widthAnchor.constriant(equalToConstant: 53).isActive = true
        //button.heightAnchor.constraint(equalToConstant: 51).isActive = true
        let item = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = item
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    @objc func infoButtonAction()  {
        print("bouton droit")
    }

    //Gestion des paramètres de jeu
    @IBAction func levelSliderAction(_ sender: UISlider) {
        let level = Int(sender.value + 0.5)
        sender.setValue(Float(level), animated: true)
        // On met à jour dans le modele
        baseJeu.setNiveauSerie(value: level)
        //On affiche
        gestionAffichageParametres()
    }
    @IBAction func segmentedSpeedAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            speed = .lent
        case 1:
            speed = .moyen
        case 2:
            speed = .rapide
        default:
            speed = .moyen
        }
        // Mise à jour de la vitessebaseJeu.se
        baseJeu.setVitesse(v: speed)
        gestionAffichageParametres()
    }
    
    func gestionAffichageParametres() {
        let level = baseJeu.getNiveau()
        levelLabel.text = "Level : " + "\(level)"
        levelSlider.value = Float(level)
        let vitesse = baseJeu.getVitesse()
        speedLabel.text = "Speed : \(vitesse)"
        switch vitesse {
        case .lent:
            segmentedSpeed.selectedSegmentIndex = 0
        case .moyen:
            segmentedSpeed.selectedSegmentIndex = 1
        case .rapide:
            segmentedSpeed.selectedSegmentIndex = 1
        default:
            segmentedSpeed.selectedSegmentIndex = 0
        }
    }
    
    @objc func toCatchIt(_ sender: UITapGestureRecognizer) {
        //print("entrée dans la fonction de saut")
        let mainStryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = mainStryboard.instantiateViewController(withIdentifier: "PlayViewController") as! PlayViewController
        vc.gestFile = baseJeu
        //self.present(vc, animated: true, completion: nil)
        //navigationController?.pushViewController(PlayViewController() as! UIViewController, animated: true)
        guard let Joueur = baseJeu.currentPlayer else {return}
        if namePlayer == Joueur.nom {
            performSegue(withIdentifier: PLAY, sender: nil)
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
        cell.detailTextLabel?.text = "Bilan : \(joueur.score)" //String(joueur.score)
        //print("\(joueur.nom)")
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let player = baseJeu.players[indexPath.row]
        miseAJourChampNom(nom: player.nom)
        validationNamePlayer(player: player.nom)
        return indexPath
    }
    
    /**/
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == PLAY {
            let vc = segue.destination as! PlayViewController
            vc.gestFile = baseJeu
        }
        
        
    }
    

}
