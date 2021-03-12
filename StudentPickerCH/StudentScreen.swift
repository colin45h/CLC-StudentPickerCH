//
//  ViewController.swift
//  StudentPickerCH
//
//  Created by Tiger Coder on 3/5/21.
//

import UIKit
import Firebase

class StudentScreen: UIViewController {

    @IBOutlet weak var clickInterface: UIButton!
    @IBOutlet weak var clickLabel: UILabel!
    
    var name = "UserDefault Name Error."
    var gameID: String = "demoGame"
    var gameListener: ListenerRegistration!
    
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil

    var clicks: Int = 0
    var defaults = UserDefaults.standard
    var gameIsActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let sesh = defaults.object(forKey: "name") as? Data {
            name = String(decoding: sesh, as: UTF8.self)
        }
        
        if let sesh = defaults.object(forKey: "gameID") as? Data {
           gameID = String(decoding: sesh, as: UTF8.self)
        }
        
        clicks = 0
        clickInterface.isHidden = true
        
        gameListener = db.collection("games").document("gameID").addSnapshotListener { (docSnapshot, error) in
            //            if let error = error {
            //                print("There was an error with the database connection: \(error.localizedDescription)")
            //            } else {
            //                print("Data fetched successfully.")
            //            }
            
            guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
            let myData = docSnapshot.data()
            self.gameIsActive = myData?["isActive"] as? Bool ?? false
        }
        
        if gameIsActive == false {
            clickInterface.isHidden = false
            
            ref = db.collection("games").document(gameID).collection("students").addDocument(data: [
                "clicks" : clicks,
                "name" : name
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Student added with ID: \(self.ref!.documentID)")
                }
            }
            
            let alert = UIAlertController(title: "Nice!", message: "The Game is over! Teacher will announce winner!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gameListener.remove()
    }

    @IBAction func clickButton(_ sender: UIButton) {
        
        clicks += 1
        clickLabel.text = "Number of Clicks: \(clicks)"
    }
    
}

