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
        name = nameTextField.text
        defaults.setValue(name, forKey: "name")
        
        performSegue(withIdentifier: "studentGo", sender: nil)
    }
    
    @IBAction func teacherButton(_ sender: UIButton) {
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
