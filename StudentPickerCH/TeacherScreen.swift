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
        if let sesh = defaults.object(forKey: "name") as? Data {
            name = String(decoding: sesh, as: UTF8.self)
        }
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        
        ref = db.collection("games").addDocument(data: [
            "isActive" : true,
            "timePlayed" : Timestamp()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.ref!.documentID)")
            }
        }
        
        endButton.isHidden = false
        startButton.isHidden = true
    }
    
    @IBAction func endGame(_ sender: UIButton) {
        db.collection("games").document("\(ref!.documentID)").setData([
            "isActive" : false
        ])
        
        db.collection("games").document(ref!.documentID).collection("students").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    // print("\(document.documentID) => \(document.data())")
                    
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
        }
        
        print(students)
        
        students.sort(by: { $0.clicks < $1.clicks } )
        
        var potentialStudents: [Student] = []
        let lowClicks = students[0].clicks
        var potentialString = ""
        
        for student in students {
            if student.clicks == lowClicks {
                potentialStudents.append(student)
                potentialString += "\(student.name ?? "Name Output Error."), "
            }
        }
        studentListLabel.text = potentialString
        
        let theChosenOne = potentialStudents.randomElement()
        chosenStudentLabel.text = theChosenOne?.name ?? "Name Output Error."
        
        endButton.isHidden = true
        startButton.isHidden = false
    }
}
