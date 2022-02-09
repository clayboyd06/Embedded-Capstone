//
//  deviceControlFunctions.swift
//  Terrabox
//
//  Created by Clay Boyd on 2/2/22.
//

import Foundation
import Firebase
import FirebaseDatabase
import UIKit

class FBFunction {
    // wont let me use ref with static functions
    static var ref = Database.database().reference()
    
    // reads the database child for temp
    // database stores currentTemp as [String: Any]
    static func readCurrentTemp(deviceID: String) {
        ref.child("device").child(deviceID).child("recieved").observeSingleEvent(of: .value, with: {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {return}
            let currentTemp =  val["temperature_readings"] as! Int
            //do SetDisplaySlider to currentTemp value
            print(currentTemp)
        })
    }
    
    // reads and displays the current humidity in the box
    static func readCurrentHum(deviceID: String) {
        ref.child("device").child(deviceID).child("recieved").observeSingleEvent(of: .value, with: {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {return}
            let currentHum =  val["humidity_readings"] as! Int
            //do SetDisplaySlider to currentHum value
            print(currentHum)
        })
    }
    
    // Tie to increment temperature button
    static func incSetTemp(deviceID: String) {
        ref.child("device").child(deviceID).child("sendback").observeSingleEvent(of: .value, with: {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {return}
            let currentSetTemp =  val["target_temp"] as! Int
            let newTemp = currentSetTemp + 1
            self.setTemp(deviceID: deviceID, setTemp: newTemp)
            //do SetDisplaySlider to newTemp value
        })
    }
    
    // Tie to decrement temperature button
    static func decSetTemp(deviceID: String) {
        ref.child("device").child(deviceID).child("sendback").observeSingleEvent(of: .value, with: {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {return}
            let currentSetTemp =  val["target_temp"] as! Int
            let newTemp = currentSetTemp - 1
            self.setTemp(deviceID: deviceID, setTemp: newTemp)
            //do SetDisplaySlider to newTemp value
        })
    }
    
    // Tie to increment humidity button
    static func incSetHum(deviceID: String ) {
        ref.child("device").child(deviceID).child("sendback").observeSingleEvent(of: .value, with: {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {return}
            let currentSetHum =  val["target_humidity"] as! Int
            let newHum = currentSetHum + 1
            self.setHum(deviceID: deviceID, setHum: newHum)
            //do SetDisplaySlider to newTemp value
        })
    }
    
    // Tie to decrement humidity button
    static func decSetHum(deviceID: String) {
        ref.child("device").child(deviceID).child("sendback").observeSingleEvent(of: .value, with: {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {return}
            let currentSetHum =  val["target_humidity"] as! Int
            let newHum = currentSetHum - 1
            self.setHum(deviceID: deviceID, setHum: newHum)
            //do SetDisplaySlider to newTemp value
        })
    }
    
    static func setHum(deviceID: String, setHum: Int){
        let post = ["target_humidity": setHum] as [String:Any]
        ref.child("device").child(deviceID).child("sendback").setValue(post)
    }
    
    static func setTemp(deviceID: String, setTemp: Int){
        let post = ["target_temp": setTemp] as [String:Any]
        ref.child("device").child(deviceID).child("sendback").setValue(post)
    }
    
    static func ledButtonTap(deviceID: String, button: String) { // not actually a string but a UIButton
        if button /*.property that is set when leds are on for example, displays "ON" */ == "" { // or could make read database but requires more code and is slower
            setLED(deviceID: deviceID, led: false)
            // change button property to that of when it is false for example, Display "OFF"
        } else {
            setLED(deviceID: deviceID, led: true)
            // change property to "ON" state indicator
        }
    }
    
    static func rainButtonTap(deviceID: String, button: String) { // not actually a string but a UIButton
        if button /*.property that is set when leds are on for example, displays "ON" */ == "" { // or could make read database but requires more code and is slower
            setRain(deviceID: deviceID, rain: false)
            // change button property to that of when it is false for example, Display "OFF"
        } else {
            setRain(deviceID: deviceID, rain: true)
            // change property to "ON" state indicator
        }
    }
    
    static func setLED(deviceID: String, led: Bool) {
        let post = ["activate_lights": led]
        ref.child("device").child(deviceID).child("sendback").setValue(post)
    }
    
    static func setRain(deviceID: String, rain: Bool) {
        let post = ["activate_sprinklers": rain]
        ref.child("device").child(deviceID).child("sendback").setValue(post)
    }
    
    // takes in device id and preset environment conditions as NSDictionary
    //environment = ["activate_lights": 0, <- check wit Kahn to see if bool or                                          int is better
    //              "activate_sprinklers": 0,
    //              "target_humidity":66,
    //              "target_temp": 19] as [String: Any]
    static func setPresetEnviornment(deviceID: String, environment: NSDictionary) {
        self.ref.child("device").child(deviceID).child("sendback").setValue(environment)
        
        
        // probably do not need to create blank data post for recieved items,
        // pi should create this post
        // but in case you are wondering what info pi will send to fb to create corresponding displys in app:
        
        /*let recieved = ["cool_fan_active": 0,
                        "heat_fan_active": 0,
                        "heater_active": 0,
                        "humidity_readings": 0,
                        "light_active": 0,
                        "sprinlers_active": 0,
                        "temperature_readings": 0]
        self.ref.child("device").child(devID).child("recieved").setValue(recieved)*/
    }
        
    
    
}
