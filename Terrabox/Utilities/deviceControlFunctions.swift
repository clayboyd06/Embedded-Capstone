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
    private let ref = Database.database().reference()
    
    /// reads the database child for temp
    /// database stores currentTemp as [String: Any]
    ///
    func readCurrentTemp(deviceID: String) {
        ref.child("device").child(deviceID).observeSingleEvent(of: .value, with: {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {return}
            let currentTemp =  val["currentTemp"] as! Int
            //do SetDisplaySlider to currentTemp value
            print(currentTemp)
        })
    }
    
    // reads and displays the current humidity in the box
    func readCurrentHum(deviceID: String) {
        ref.child("device").child(deviceID).observeSingleEvent(of: .value, with: {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {return}
            let currentHum =  val["currentHumidity"] as! Int
            //do SetDisplaySlider to currentHum value
            print(currentHum)
        })
    }
    
    // Tie to increment temperature button
    func incSetTemp(deviceID: String) {
        ref.child("device").child(deviceID).observeSingleEvent(of: .value, with: {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {return}
            let currentSetTemp =  val["setTemp"] as! Int
            let newTemp = currentSetTemp + 1
            self.setTemp(deviceID: deviceID, setTemp: newTemp)
            //do SetDisplaySlider to newTemp value
        })
    }
    
    // Tie to decrement temperature button
    func decSetTemp(deviceID: String) {
        ref.child("device").child(deviceID).observeSingleEvent(of: .value, with: {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {return}
            let currentSetTemp =  val["setTemp"] as! Int
            let newTemp = currentSetTemp - 1
            self.setTemp(deviceID: deviceID, setTemp: newTemp)
            //do SetDisplaySlider to newTemp value
        })
    }
    
    // Tie to increment humidity button
    func incSetHum(deviceID: String) {
        ref.child("device").child(deviceID).observeSingleEvent(of: .value, with: {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {return}
            let currentSetHum =  val["setHumidity"] as! Int
            let newHum = currentSetHum + 1
            self.setHum(deviceID: deviceID, setHum: newHum)
            //do SetDisplaySlider to newTemp value
        })
    }
    
    // Tie to decrement humidity button
    func decSetHum(deviceID: String) {
        ref.child("device").child(deviceID).observeSingleEvent(of: .value, with: {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {return}
            let currentSetHum =  val["setHumidity"] as! Int
            let newHum = currentSetHum - 1
            self.setHum(deviceID: deviceID, setHum: newHum)
            //do SetDisplaySlider to newTemp value
        })
    }
    
    func setHum(deviceID: String, setHum: Int){
        let post = ["setHumidity": setHum] as [String:Any]
        ref.child("device").child(deviceID).setValue(post)
    }
    
    func setTemp(deviceID: String, setTemp: Int){
        let post = ["setTemp": setTemp] as [String:Any]
        ref.child("device").child(deviceID).setValue(post)
    }
    
    func ledButtonTap(deviceID: String, button: String) { // not actually a string but a UIButton
        if button /*.property that is set when leds are on for example, displays "ON" */ == "" { // or could make read database but requires more code and is slower
            setLED(deviceID: deviceID, led: false)
            // change button property to that of when it is false for example, Display "OFF"
        } else {
            setLED(deviceID: deviceID, led: true)
            // change property to "ON" state indicator
        }
    }
    
    func rainButtonTap(deviceID: String, button: String) { // not actually a string but a UIButton
        if button /*.property that is set when leds are on for example, displays "ON" */ == "" { // or could make read database but requires more code and is slower
            setRain(deviceID: deviceID, rain: false)
            // change button property to that of when it is false for example, Display "OFF"
        } else {
            setRain(deviceID: deviceID, rain: true)
            // change property to "ON" state indicator
        }
    }
    
    func setLED(deviceID: String, led: Bool) {
        let post = ["led": led]
        ref.child("device").child(deviceID).setValue(post)
    }
    
    func setRain(deviceID: String, rain: Bool) {
        let post = ["precipitation": rain]
        ref.child("device").child(deviceID).setValue(post)
    }
    
    // takes in device id and preset environment conditions as NSDictionary
    func setPresetEnviornment(deviceID: String, environment: NSDictionary) {
        guard let led = environment["led"] else {return}
        guard let rain = environment["precipitation"] else {return}
        guard let setTemp = environment["setTemp"] else {return}
        guard let setHum = environment["setHum"] else {return}
        
        
        let post = ["led": led,
                    "precipitation": rain,
                    "setTemp" : setTemp,
                    "currentTemp": 0, // when you read the temp you should probably just store it as variable and plug that back in here
                    "setHumidity" : setHum ,   // or just remove it current temp key and currentHumidity key and I think those vals wont change
                    "currentHumidity":0] as [String: Any]
        ref.child("device").child(deviceID).setValue(post)
    }
        
    
    
}
