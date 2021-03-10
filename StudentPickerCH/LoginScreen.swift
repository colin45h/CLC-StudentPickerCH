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
    var ref: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func studentButton(_ sender: UIButton) {
        let name = nameTextField.text ?? "No Name!"
        
        db.collection("student").addDocument(data: [
            "name" : name,
            "clicks" : 0
        ])
        
        performSegue(withIdentifier: "studentGo", sender: nil)
    }
    
    @IBAction func teacherButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: "teacherGo", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.destination is StudentScreen {
            let vc = segue.destination as? StudentScreen
            vc?.docRef = ref
        }
    }
}
