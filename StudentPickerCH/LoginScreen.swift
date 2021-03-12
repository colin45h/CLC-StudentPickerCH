//
//  LoginScreen.swift
//  StudentPickerCH
//
//  Created by Tiger Coder on 3/8/21.
//

import UIKit
import Firebase

class LoginScreen: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    let db = Firestore.firestore()
    var name: String?
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func studentButton(_ sender: UIButton) {
        if(nameTextField.text == "") {
            let alert = UIAlertController(title: "Oops!", message: "You forgot to enter a name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        name = nameTextField.text
        defaults.setValue(name, forKey: "name")
        
        var gameList: [Game] = []
        
        db.collection("games").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    // print("\(document.documentID) => \(document.data())")
                    
                    let gameMade = Game()
                    gameMade.gameID = document.documentID
                    
                    for dt in document.data() {
                        if dt.key == "isActive" {
                            gameMade.isActive = dt.value as? Bool ?? false
                        }
                        if dt.key == "teacherName" {
                            gameMade.teacherName = dt.value as? String ?? "Teacher name receive error."
                        }
                    }
                    
                    gameList.append(gameMade)
                }
            }
            
//            for game in gameList {
//                game.printGameData()
//            }
            
            var con = 0
            var currentGameID = ""
            
            for game in gameList {
                if (game.isActive == true) {
                    con = 1
                    currentGameID = game.gameID
                    break
                }
            }
            
            if (con == 0){
                let alert = UIAlertController(title: "Oops!", message: "There are no games currently in progress.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                }))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
        
            self.defaults.setValue(currentGameID, forKey: "gameID")
        
            self.performSegue(withIdentifier: "studentGo", sender: nil)
        }
    }
    
    @IBAction func teacherButton(_ sender: UIButton) {
        if(nameTextField.text == "") {
            let alert = UIAlertController(title: "Oops!", message: "You forgot to enter a name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        name = nameTextField.text
        defaults.setValue(name, forKey: "name")
        
        performSegue(withIdentifier: "teacherGo", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.destination is StudentScreen {
            let vc = segue.destination as? StudentScreen
            vc?.name = name ?? "No Name!"
        }
        if segue.destination is TeacherScreen {
            let vc = segue.destination as? TeacherScreen
            vc?.name = name ?? "Default Teacher."
        }
    }
}
