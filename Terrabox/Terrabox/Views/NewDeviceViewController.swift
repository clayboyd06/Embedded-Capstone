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

    // View outliets
    @IBOutlet weak var deviceIDLable: UILabel!
    @IBOutlet weak var deviceID: UITextField!
    @IBOutlet weak var addDevButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentHumidLabel: UILabel!
    @IBOutlet weak var tempDown: UIButton!
    @IBOutlet weak var tempUp: UIButton!
    @IBOutlet weak var humidUp: UIButton!
    @IBOutlet weak var sprinkTextField: UITextField!
    @IBOutlet weak var sprinklerLabel: UILabel!
    @IBOutlet weak var ledTextField: UITextField!
    @IBOutlet weak var ledLabel: UILabel!
    @IBOutlet weak var humidDown: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    var newTemp: Int = 0
    var newHumid: Int = 0
    guard let devID = deviceID.text else {return}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleElements()
        
    }
    
    // Sets the style for the view elements
    func styleElements(){
        Utils.styleFilledButton(addDevButton)
        Utils.styleFilledButton(tempDown)
        Utils.styleFilledButton(refreshButton)
        Utils.styleFilledButton(tempUp)
        Utils.styleFilledButton(humidUp)
        Utils.styleFilledButton(humidDown)
        Utils.styleLabel(deviceIDLable)
        Utils.styleLabel(sprinklerLabel)
        Utils.styleLabel(ledLabel)
        Utils.styleLabel(currentTempLabel)
        Utils.styleLabel(currentHumidLabel)
        Utils.styleTextField(deviceID)
        Utils.styleTextField(ledTextField)
        Utils.styleTextField(sprinkTextField)
    }
    
    // TODO get readung workings
    func displayDBValues() {
        if devID != "" {
            ref.child("device").child(devID).child("sendback").observeSingleEvent(of: .value, with: {DataSnapshot in
                guard let val = DataSnapshot.value as? NSDictionary else {return}
                let targetHum =  val["target_humidity"] as! Int
                let targetTemp =  val["target_temp"] as! Int
                
                self.currentTempLabel.text = "Current Temperature:  \(targetTemp)"
                self.currentHumidLabel.text = "Current Humidity: \(targetHum)"
                
                self.newHumid = targetHum
                self.newTemp = targetTemp
            })
            
//            self.currentTempLabel.text = "Current Temperature:  \(self.newTemp)"
//            self.currentHumidLabel.text = "Current Humidity: \(self.newHumid)"
        }
    }

    @IBAction func tempUpTapped(_ sender: Any) {
        if devID != "" {
            ref.child("device").child(devID).child("sendback").observeSingleEvent(of: .value, with: {DataSnapshot in
                guard let val = DataSnapshot.value as? NSDictionary else {return}
                let currentSetTemp =  val["target_temp"] as! Int
                self.newTemp = currentSetTemp + 1
            })
            setValues()
        }
    }
                                                                              
    
    @IBAction func refreshTapped(_ sender: Any) {
        guard let devID = deviceID.text else {return}
        if devID != "" {
            displayDBValues()
            
        }
    }
    
    @IBAction func tempDownTapped(_ sender: Any) {
        if devID != "" {
            ref.child("device").child(devID).child("sendback").observeSingleEvent(of: .value, with: {DataSnapshot in
                guard let val = DataSnapshot.value as? NSDictionary else {return}
                let currentSetTemp =  val["target_temp"] as! Int
                self.newTemp = currentSetTemp - 1
            })
            setValues()
        }
    }
    
    @IBAction func humUpTapped(_ sender: Any) {
        guard let devID = deviceID.text else {return}
        if devID != "" {
            ref.child("device").child(devID).child("sendback").observeSingleEvent(of: .value, with: {DataSnapshot in
                guard let val = DataSnapshot.value as? NSDictionary else {return}
                let currentSetHum =  val["target_humidity"] as! Int
                self.newHumid = currentSetHum + 1
            })
            setValues()
        }
    }
    
    
    @IBAction func humDownTapped(_ sender: Any) {
        guard let devID = deviceID.text else {return}
        if devID != "" {
            ref.child("device").child(devID).child("sendback").observeSingleEvent(of: .value, with: {DataSnapshot in
                guard let val = DataSnapshot.value as? NSDictionary else {return}
                let currentSetHum =  val["target_humidity"] as! Int
                self.newHumid = currentSetHum - 1
            })
            setValues()
        }
    }
    
    
    // Adds a new device as a post for the current user
    // Additionally, if the device does not yet exist in the DB,
    // this function creates a blank entry for a new device
    // To limit db storage, eventually the rasberry Pi should be the only entity able to add devices to the device list, so that devices that do not exist do not fill db
    @IBAction func addDevButtonTapped(_ sender: Any) {
        if devID != "" {
            setValues()
        } else {
            resetForm()
        }
        
        
        /*
        if devID != ""{
            let userPost = ["Device ID": devID] as [String: String] // turn this into a list append
            // checks the db to see if device exists before overwriting the values
            ref.child("device").child(devID).observe(DataEventType.value) { snapshot in
                // if the device does not exist, then there will be no children, so create a initial settings
                if snapshot.childrenCount == 0  {
                    let sendback = ["activate_lights": 0,
                                    "activate_sprinklers": 0,
                                    "target_humidity":66,
                                    "target_temp": 19] as [String: Any]
                    // probably do not need to create blank data post
                    /*let recieved = ["cool_fan_active": 0,
                                    "heat_fan_active": 0,
                                    "heater_active": 0,
                                    "humidity_readings": 0,
                                    "light_active": 0,
                                    "sprinlers_active": 0,
                                    "temperature_readings": 0]
                    self.ref.child("device").child(devID).child("recieved").setValue(recieved)*/
                    self.ref.child("device").child(devID).child("sendback").setValue(sendback)
                }
            }
            // adds the new device to the user anyway
            self.ref.child("users").child(userID).child("devices").child("Device \(devID)").setValue(userPost)
            self.dismiss(animated: false, completion: nil)
        } else {
            print("Form empty")
            resetForm()
        }*/
    }

    func setValues() {
        if devID != "" {
            if ledTime != "" && sprinTime != "" {
                let sendback = ["activate_lights": ledTime,
                                "activate_sprinklers": sprinTime,
                                "target_humidity":self.newHumid,
                                "target_temp": self.newTemp] as [String: Any]
                self.ref.child("device").child(devID).child("sendback").setValue(sendback)
            } else {
                let sendback = ["activate_lights": 0,
                                "activate_sprinklers": 0,
                                "target_humidity":self.newHumid,
                                "target_temp": self.newTemp] as [String: Any]
                self.ref.child("device").child(devID).child("sendback").setValue(sendback)
            }
        } else {
            resetForm()
        }
    }
    
    
    // returns to the home view controller
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // Gives the user an alert to fill in the field, and then re-enables the add device button
    func resetForm() {
        let alert = UIAlertController(title: "Fill in all text fields", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default , handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        Utils.setContinueButton(enabled: true, button: addDevButton)
        addDevButton.setTitle("Update Conditions", for: .normal)
    }
       
} // EOC
