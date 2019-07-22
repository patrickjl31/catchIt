//
//  SuiviJoueurViewController.swift
//  catchIt
//
//  Created by patrick lanneau on 31/08/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

class SuiviJoueurViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var leJoueur: Player?
    
    @IBOutlet weak var ui_labelTitre: UILabel!
    
    @IBOutlet weak var joueurTableView: UITableView!
    @IBOutlet weak var sousTable: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let joueur = leJoueur{
            ui_labelTitre.text = NSLocalizedString("Games played by", comment: "Les parties jouées par") + " \(joueur.nom)"
        }
        joueurTableView.dataSource = self
        joueurTableView.delegate = self
        
        
        /**/
        // Décor tableview
        sousTable.layer.masksToBounds = false
        sousTable.layer.borderWidth = 4.0
        sousTable.layer.borderColor = MARRON.cgColor
        sousTable.layer.cornerRadius = 20.0
        sousTable.layer.shadowOpacity = 0.7
        sousTable.layer.shadowRadius = 5.0
        sousTable.layer.shadowOffset = CGSize(width: 3, height: 3)
        sousTable.layer.shadowColor = UIColor.black.cgColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OKAction(_ sender: Any) {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let joueur = leJoueur {
            return joueur.resultats.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_PARTIE, for: indexPath)
        var laDate = ""
        var lesInfos = ""
        var pluriel = ""
        if let resPartie = leJoueur?.resultats[indexPath.row] {
            let datePartie = resPartie.date
            let fDateJourFormat = DateFormatter()
            let motATrouver = String(resPartie.motCible.dropLast())
            fDateJourFormat.dateFormat = "dd MMMM yy"
            let fDateHeureFormat = DateFormatter()
            fDateHeureFormat.dateFormat = "HH:mm:ss"
            laDate = NSLocalizedString("The ", comment: "Le ") + fDateJourFormat.string(from: datePartie ) + NSLocalizedString("at ", comment: "à ")  + fDateHeureFormat.string(from: datePartie)
            lesInfos = NSLocalizedString("Hunt of ", comment: "Chasse de ")  + "\(motATrouver)\" ,"
            if resPartie.succes {
                if resPartie.nombreDeTaps > 1{
                    pluriel = "s"
                }
                lesInfos += NSLocalizedString("Catched with ", comment: "Trouvé en ") + "\(resPartie.nombreDeTaps) tap" + pluriel + "."
            } else {
                lesInfos += NSLocalizedString("Missed... ", comment: " Raté...")
            }
            //print(lesInfos)
        }
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = BLANC
        } else {
            cell.backgroundColor = GRIS_TRES_CLAIR
        }
       
        cell.textLabel?.text = laDate
        cell.detailTextLabel?.text = lesInfos
        
        return cell
    }
    
}
