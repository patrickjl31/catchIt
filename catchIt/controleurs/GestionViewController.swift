//
//  GestionViewController.swift
//  catchIt
//
//  Created by patrick lanneau on 19/07/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

class GestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate, UIPopoverControllerDelegate {
   

    // paramètres globaux
    var baseJeu:GestionFiles = GestionFiles()
    
    @IBOutlet weak var btnAbout: UIBarButtonItem!
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
    // l'indice du joueur à analyser
    var joueurASuivre = -1
    
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
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.titleTextAttributes = [.font: FONT_DE_BASE as Any, .foregroundColor: ROUGE]
        //self.navigationController?.navigationBar.tintColor = GRIS_TRES_CLAIR
        //self.navigationController?.navigationBar.barTintColor = GRIS_TRES_FONCE
        
        
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
        /*
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named: "Icon-29.png"), for: .normal)
        button.addTarget(self, action: #selector(infoButtonAction), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        //translatesAutoresizingMaskIntoConstraints as false
        //button.widthAnchor.constriant(equalToConstant: 53).isActive = true
        //button.heightAnchor.constraint(equalToConstant: 51).isActive = true
        let item = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = item
        */
        let ballButton = UIButton(type: .system)
        ballButton.setImage(#imageLiteral(resourceName: "info28").withRenderingMode(.alwaysOriginal), for: .normal)
        ballButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        ballButton.addTarget(self, action: #selector(infoButtonAction), for: .touchUpInside)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: ballButton), btnAbout]
        
        // On met à jour la table
        tablePlayers.reloadData()
        //btnAbout.image = UIImage(named: "info28")
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    @objc func infoButtonAction()  {
        //print("bouton droit")
        //performSegue(withIdentifier: ABOUT, sender: nil)
        /*
        let vc = AboutViewController()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
        vc.popoverPresentationController?.sourceView = view
        vc.popoverPresentationController?.sourceRect = CGRect(x: view.frame.maxX - 50, y: view.frame.minY - 50, width: 200, height: 400)
 */
        performSegue(withIdentifier: ABOUT, sender: self)
    }
    
    @IBOutlet weak var infobuttonAction2: UIBarButtonItem!
    
    //Gestion des paramètres de jeu
    @IBAction func addPlayer(_ sender: Any) {
        let alerte = UIAlertController(title: "Nouveau joueur", message: "Quel est son nom ?", preferredStyle: .alert)
        alerte.addTextField { (champ) in
            champ.text = ""
            alerte.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                let cNom = alerte.textFields?[0] as! UITextField
                if let nom = cNom.text,
                    nom.count > 0 {
                    self.miseAJourChampNom(nom: nom)
                    _ = self.validationNamePlayer(player: nom)
                }
                
            }))
            
        }
        present(alerte, animated: true, completion: nil)
    }
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
    // Si ce joueur n'existe pas, on le crée
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
            view.endEditing(true)
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
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        joueurASuivre = indexPath.row
        let player = baseJeu.players[indexPath.row]
        performSegue(withIdentifier: SUIVI, sender: nil)
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
        /* */
        if segue.identifier == ABOUT{
            if let vc = segue.destination as? AboutViewController {
                /*
                if let pvc = vc.popoverPresentationController {
                    pvc.delegate = self
                }
                //vc.popoverPresentation.delegate = self
                vc.preferedContentSize = CGS
 */
                //vc.modalPresentationStyle = UIModalPresentationStyle.popover
                //vc.popoverPresentationController?.delegate = self as! UIPopoverPresentationControllerDelegate
            }
            
        }
        
        if segue.identifier == SUIVI {
            if let vc = segue.destination as? SuiviJoueurViewController {
                vc.leJoueur = baseJeu.players[joueurASuivre]
                //vc.popoverPresentationController?.delegate = self as! UIPopoverPresentationControllerDelegate
                vc.popoverPresentationController?.sourceView = view
                vc.popoverPresentationController?.sourceRect = tablePlayers.frame
                //vc.preferredContentSize = CGRect(x: tablePlayers.frame.minX, y: tablePlayers.frame.minY, width: 0, height: 0)
            }
        }
        
        
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

}
