//
//  deviceControlFunctions.swift
//  Terrabox
//
//  Created by Clay Boyd on 2/2/22.
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
    var ref = Database.database().reference()
    
    private var light: Int = 0
    private var rain: Int = 0
    private var humid: Int = 80
    private var temp: Int = 70
    
    var targetHum: Int = 0
    var targetTemp: Int = 0
    var actLights: Int = 0
    var actSprink: Int = 0
    
    var light_hours: Int = 0
    var light_min: Int = 0
    var light_sec: Int = 0
    
    var sprink_days: Int = 0
    var sprink_hours: Int = 0
    var sprink_min: Int = 0
    var sprink_sec: Int = 0
    

    var humidity_readings: Int = 100
    var light_active: Int = 100
    var water_stat: Int = 100
    var temperature_readings: Int = 100

    // reads the database child for temp
    // database stores currentTemp as [String: Any]
    // @param deviceID: the deviceID to edit
    func readCurrentTemp(deviceID: String) {
        ref.child("device").child(deviceID).child("recieved").observeSingleEvent(of: .value, with: {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {return}
            let currentTemp =  val["temperature_readings"] as! Int
            //do SetDisplaySlider to currentTemp value
            print(currentTemp)
        })
    }

    // reads and displays the current humidity in the box
    // @param deviceID: the deviceID to read
    func readCurrentHum(deviceID: String) {
        ref.child("device").child(deviceID).child("recieved").observeSingleEvent(of: .value, with: {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {return}
            let currentHum =  val["humidity_readings"] as! Int
            //do SetDisplaySlider to currentHum value
            print(currentHum)
        })
    }


    // Reads the database and increments the temperature
    // @param deviceID: the deviceID to edit
    func incSetTemp(deviceID: String) {
        ref.child("device").child(deviceID).child("sendback").observeSingleEvent(of: .value, with: {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {return}
             let currentSetTemp =  val["target_temp"] as! Int
             let newTemp = currentSetTemp + 1
            self.temp = newTemp
            // self.setTemp(deviceID: deviceID, setTemp: newTemp)
            //do SetDisplaySlider to newTemp value
            self.setValues(deviceID: deviceID)
        })
    }

    // Reads the database and decrements the temperature
    // @param deviceID: the deviceID to edit
    func decSetTemp(deviceID: String) {
        ref.child("device").child(deviceID).child("sendback").observeSingleEvent(of: .value, with: {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {return}
            let currentSetTemp =  val["target_temp"] as! Int
            let newTemp = currentSetTemp - 1
            if newTemp >= 0 {
                self.temp = newTemp
            } else {
                self.temp = 0
            }
            // self.setTemp(deviceID: deviceID, setTemp: newTemp)
            //do SetDisplaySlider to newTemp value
            self.setValues(deviceID: deviceID)
        })
    }

    // Reads the database and increments the humidity
    // @param deviceID: the deviceID to edit
     func incSetHum(deviceID: String ) {
        ref.child("device").child(deviceID).child("sendback").observeSingleEvent(of: .value, with: {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {return}
            let currentSetHum =  val["target_humidity"] as! Int
            let newHum = currentSetHum + 1
            self.humid = newHum
            // self.setHum(deviceID: deviceID, setHum: newHum)
            //do SetDisplaySlider to newTemp value
            self.setValues(deviceID: deviceID)
        })
    }

    // Reads the database and decrements the humidity
    // @param deviceID: the deviceID to edit
    func decSetHum(deviceID: String) {
        ref.child("device").child(deviceID).child("sendback").observeSingleEvent(of: .value, with: {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {return}
            let currentSetHum =  val["target_humidity"] as! Int
            let newHum = currentSetHum - 1
            if newHum >= 0 {
                self.humid = newHum
            } else {
                self.humid = 0
            }
            self.setValues(deviceID: deviceID)
        })
    }

    // Reads the database and increments the light on time
    // @param deviceID: the deviceID to edit
    func incSetLight(deviceID: String ) {
        ref.child("device").child(deviceID).child("sendback").observeSingleEvent(of: .value, with: {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {return}
            guard let lightTime =  val["light_time"] as? NSDictionary else {return}
            let lightMin = lightTime["minute"] as! Int
            let new_min = lightMin + 1
            self.light_min = new_min
            self.light = 1
            self.setValues(deviceID: deviceID)
        })
    }

    // Reads the database and decrements the light on time
    // @param deviceID: the deviceID to edit
    func decSetLight(deviceID: String ) {
       ref.child("device").child(deviceID).child("sendback").observeSingleEvent(of: .value, with: {DataSnapshot in
           guard let val = DataSnapshot.value as? NSDictionary else {return}
           guard let lightTime =  val["light_time"] as? NSDictionary else {return}
           let lightMin = lightTime["minute"] as! Int
           let new_min = lightMin - 1
           if new_min >= 0 {
                self.light_min = new_min
               self.light = 1
           } else {
               self.light_min = 0
               self.light = 0
           }
           self.setValues(deviceID: deviceID)
       })
   }
    
    // Reads the database and increments the sprinkler wait time
    // @param deviceID: the deviceID to edit
    func incSetRain(deviceID: String ) {
       ref.child("device").child(deviceID).child("sendback").observeSingleEvent(of: .value, with: {DataSnapshot in
           guard let val = DataSnapshot.value as? NSDictionary else {return}
           guard let lightTime =  val["sprinkler_time"] as? NSDictionary else {return}
           let sprinkMin = lightTime["minute"] as! Int
           let new_min = sprinkMin + 1
           self.sprink_min = new_min
           self.rain = 1
           self.setValues(deviceID: deviceID)
       })
   }

    // Reads the database and decreases the sprinkler wait time
    // @param deviceID: the deviceID to edit
    func decSetRain(deviceID: String ) {
       ref.child("device").child(deviceID).child("sendback").observeSingleEvent(of: .value, with: {DataSnapshot in
           guard let val = DataSnapshot.value as? NSDictionary else {return}
           guard let lightTime =  val["sprinkler_time"] as? NSDictionary else {return}
           let sprinkMin = lightTime["minute"] as! Int
           let new_min = sprinkMin - 1
           if new_min >= 0 {
               self.sprink_min = new_min
               self.rain = 1
           } else {
               self.sprink_min = 0
               self.rain = 0
           }
           self.setValues(deviceID: deviceID)
       })
   }

    // reads each field in the instance of the class and updates the database values
    //
    // usually only one value will be changed, but this function preserves the layout of
    //the database post
    // @param deviceID: the deviceID to edit
    func setValues(deviceID: String) {
        let sendback = ["activate_lights": self.light,
                        "activate_sprinklers": self.rain,
                        "target_humidity":self.humid,
                        "target_temp": self.temp,
                        "light_time": ["hour": self.light_hours,
                                       "minute": self.light_min,
                                       "second": self.light_sec],
                        "sprinkler_time": ["day": self.sprink_days,
                                           "hour": self.sprink_days,
                                           "minute": self.sprink_min,
                                           "second": self.sprink_sec]] as [String: Any]
        ref.child("device").child(deviceID).child("sendback").setValue(sendback)
    }
    
    // reads the database and updates all the class instance values for easy in-app access
    // @param deviceID: the deviceID to edit
    func getValues(deviceID: String) {
        if deviceID != "" {
            ref.child("device").child(deviceID).child("sendback").observeSingleEvent(of: .value, with: {DataSnapshot in
                guard let val = DataSnapshot.value as? NSDictionary else {return}
                guard let lightTime = val["light_time"] as? NSDictionary else {return}
                self.light_hours = lightTime["hour"] as! Int
                self.light_min = lightTime["minute"] as! Int
                self.light_sec = lightTime["second"] as! Int
                guard let rainTime = val["sprinkler_time"] as? NSDictionary else {return}
                self.sprink_days = rainTime["day"] as! Int
                self.sprink_hours = rainTime["hour"] as! Int
                self.sprink_min = rainTime["minute"] as! Int
                self.sprink_sec = rainTime["second"] as! Int
                self.targetHum = val["target_humidity"] as! Int
                self.targetTemp = val["target_temp"] as! Int
                self.actLights = val["activate_lights"] as! Int
                self.actSprink = val["activate_sprinklers"] as! Int
                print("sendback...")
                print(self.targetHum)
                print(self.targetTemp)
                print(self.actLights)
                print(self.actSprink)
                
            })

            ref.child("device").child(deviceID).child("received").observeSingleEvent(of: .value, with: { DataSnapshot in
                guard let rVal = DataSnapshot.value as? NSDictionary else {return}
                self.humidity_readings = rVal["humidity_readings"] as! Int
                self.light_active = rVal["light_active"] as! Int
                self.water_stat = rVal["waterlevel_readings"] as! Int
                let temp_temperature_readings = rVal["temperature_readings"] as! Double
                self.temperature_readings = Int(temp_temperature_readings)
                print("received...")
                print(self.humidity_readings)
                print(self.light_active)
                print(self.water_stat)
                print(self.temperature_readings)
            })

        }
    }
}
