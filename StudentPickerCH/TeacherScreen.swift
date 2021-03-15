//
//  TeacherScreen.swift
//  StudentPickerCH
//
//  Created by Tiger Coder on 3/8/21.
//

import UIKit
import Firebase

class TeacherScreen: UIViewController {
    
    @IBOutlet weak var studentListLabel: UILabel!
    @IBOutlet weak var chosenStudentLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    
    let db = Firestore.firestore()
    var defaults = UserDefaults.standard
    
    var name = "UserDefault Name Error."
    var ref: DocumentReference? = nil
    
    var students: [Student] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        endButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let sesh = defaults.object(forKey: "name") as? Data {
            name = String(decoding: sesh, as: UTF8.self)
        }
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        
        var gameList: [Game] = []
        
        db.collection("games").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    // print("\(document.documentID) => \(document.data())")
                    
                    let gameMade = Game()
                    
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
        }
        
        var con = 0
        for game in gameList {
            if (game.isActive == true) {
                con = 1
            }
        }
        
        if (con == 1){
            let alert = UIAlertController(title: "Oops!", message: "Looks like there is already a game in progress.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        ref = db.collection("games").addDocument(data: [
            "isActive" : true,
            "timePlayed" : Timestamp(),
            "teacherName" : name
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Game added with ID: \(self.ref!.documentID)")
            }
        }
        
        endButton.isHidden = false
        startButton.isHidden = true
    }
    
    @IBAction func endGame(_ sender: UIButton) {
        db.collection("games").document("\(ref!.documentID)").setData([
            "isActive" : false
        ], merge: true)
        
        db.collection("games").document(ref!.documentID).collection("students").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    let studentMade = Student()
                    
                    for dt in document.data() {
                        if dt.key == "clicks" {
                            studentMade.clicks = dt.value as? Int ?? 0
                        }
                        if dt.key == "name" {
                            studentMade.name = dt.value as? String ?? "Name receive error."
                        }
                    }
                    
                    self.students.append(studentMade)
                }
            }
            
            print(self.students)
            
            self.students.sort(by: { $0.clicks < $1.clicks } )
            
            if(self.students.isEmpty == true) {
                let alert = UIAlertController(title: "Oops!", message: "There are no students in your game. Ending now!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                }))
                self.present(alert, animated: true, completion: nil)
                
                self.endButton.isHidden = true
                self.startButton.isHidden = false
                
                return
            }
            
            var potentialStudents: [Student] = []
            let lowClicks = self.students[0].clicks
            var potentialString = "Students with lowest clicks: "
            
            for student in self.students {
                if student.clicks == lowClicks {
                    potentialStudents.append(student)
                    potentialString += "\(student.name ?? "Name Output Error."), "
                }
            }
            self.studentListLabel.text = potentialString
            
            let theChosenOne = potentialStudents.randomElement()
            self.chosenStudentLabel.text = "Chosen Student: \(theChosenOne?.name ?? "NAME OUTPUT ERROR.")"
            
            self.endButton.isHidden = true
            self.startButton.isHidden = false
        }
    }
}
