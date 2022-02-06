//
//  NewDeviceViewController.swift
//  Terrabox
//
//  Created by Clay Boyd on 1/29/22.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class NewDeviceViewController: UIViewController {
    
    private let ref = Database.database().reference()

    @IBOutlet weak var deviceIDLable: UILabel!
    @IBOutlet weak var deviceID: UITextField!
    @IBOutlet weak var addDevButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleElements()

        // Do any additional setup after loading the view.
    }
    
    // Sets the style for the view elements
    func styleElements(){
        Utils.styleFilledButton(addDevButton)
        Utils.styleLabel(deviceIDLable)
        Utils.styleTextField(deviceID)
    }

    // Adds a new device as a post for the current user
    // Additionally, if the device does not yet exist in the DB,
    // this function creates a blank entry for a new device
    // To limit db storage, eventually the rasberry Pi should be the only entity able to add devices to the device list, so that devices that do not exist do not fill db
    @IBAction func addDevButtonTapped(_ sender: Any) {
        guard let devID = deviceID.text else {return}
        
        Utils.setContinueButton(enabled: false, button: addDevButton)
        addDevButton.setTitle("", for: .normal)
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        
        if devID != ""{
            let userPost = ["Device ID": devID] as [String: String] // turn this into a list append
            // checks the db to see if device exists before overwriting the values
            ref.child("device").child(devID).observeSingleEvent(of: .value, with: {DataSnapshot in
                if (DataSnapshot.value) == nil  {
                        let post = ["led": false,
                                    "precipitation": false,
                                    "setTemp" : 26,
                                    "currentTemp": 0,
                                    "setHumidity" : 0 ,
                                    "currentHumidity":0] as [String: Any]
                        self.ref.child("device").child(devID).setValue(post)
                        return
                    }
                })
            // adds the new device to the user anyway
            self.ref.child("users").child(userID).child("devices").child("Device \(devID)").setValue(userPost)
            self.dismiss(animated: false, completion: nil)
        } else {
            print("Form empty")
            resetForm()
        }
    }

    // returns to the home view controller
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // Gives the user an alert to fill in the field, and then re-enables the add device button
    func resetForm() {
        let alert = UIAlertController(title: "Fill in the ID field with a valid ID to add device", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default , handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        Utils.setContinueButton(enabled: true, button: addDevButton)
        addDevButton.setTitle("Add Device", for: .normal)
    }
       
} // EOC
