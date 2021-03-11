//
//  ViewController.swift
//  StudentPickerCH
//
//  Created by Tiger Coder on 3/5/21.
//

import UIKit

class StudentScreen: UIViewController {

    @IBOutlet weak var clickLabel: UILabel!
    var name = "UserDefault Name Error."
    
    var clicks: Int = 0
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let sesh = defaults.object(forKey: "name") as? Data {
            name = String(decoding: sesh, as: UTF8.self)
        }
        
        clicks = 0
    }

    @IBAction func clickButton(_ sender: UIButton) {
        
        clicks += 1
        clickLabel.text = "Number of Clicks: \(clicks)"
    }
    
}

