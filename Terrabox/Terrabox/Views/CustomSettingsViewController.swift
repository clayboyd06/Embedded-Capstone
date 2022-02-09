//
//  CustomSettingsViewController.swift
//  Terrabox
//
//  Created by Clay Boyd on 1/29/22.
//

// UNUSED FILE




import UIKit
import Firebase
import FirebaseDatabase

class CustomSettingsViewController: UIViewController {

    private let ref = Database.database().reference()

    // Manual Control
    private let buttonLED: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Power LEDS", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let buttonPrecip: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Make it rain", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let buttonUpTemp: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Temperature ^", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let buttonDownTemp: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Temperature v", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let buttonUpHumidity: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Humidity ^", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let buttonDownHumidity: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Humidity v", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let buttonSaveAsPreset: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Save settings as new preset", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        led(state: "OFF")
        humidity(state: 5)
        temp(state: 75)
        precip(state: "OFF")
        view.backgroundColor = UIColor.systemTeal
        view.addSubview(buttonLED)
        view.addSubview(buttonPrecip)
        view.addSubview(buttonUpTemp)
        view.addSubview(buttonDownTemp)
        view.addSubview(buttonUpHumidity)
        view.addSubview(buttonDownHumidity)
        view.addSubview(buttonSaveAsPreset)
        buttonLED.addTarget(
            self,action: #selector(didTapButtonLed), for: .touchUpInside)
        buttonPrecip.addTarget(
            self, action: #selector(didTapButtonRain), for: .touchUpInside)
        buttonUpTemp.addTarget(
            self, action: #selector(didTapButtonUpTemp), for: .touchUpInside)
        buttonDownTemp.addTarget(
            self, action: #selector(didTapButtonDownTemp), for: .touchUpInside)
        buttonUpHumidity.addTarget(
            self, action: #selector(didTapButtonUpHumid), for: .touchUpInside)
        buttonDownHumidity.addTarget(
            self, action: #selector(didTapButtonDownHumid), for: .touchUpInside)
        buttonSaveAsPreset.addTarget(
            self, action: #selector(didTapButtonPreOne), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonLED.frame = CGRect(
            x: 20,
            y: view.frame.size.height - 50 - view.safeAreaInsets.bottom,
            width: (view.frame.size.width / 2 - 40),
            height: 50)
        buttonPrecip.frame = CGRect(
            x: 20,
            y: view.frame.size.height - 150 - view.safeAreaInsets.bottom,
            width: (view.frame.size.width / 2 - 40),
            height: 50)
        buttonUpTemp.frame = CGRect(
            x: 20,
            y: view.frame.size.height - 350 - view.safeAreaInsets.bottom,
            width: (view.frame.size.width / 2 - 40),
            height: 50)
        buttonDownTemp.frame = CGRect(
            x: 20,
            y: view.frame.size.height - 250 - view.safeAreaInsets.bottom,
            width: (view.frame.size.width / 2 - 40),
            height: 50)
        buttonUpHumidity.frame = CGRect(
            x: view.frame.size.width / 2 + 20,
            y: view.frame.size.height - 150 - view.safeAreaInsets.bottom,
            width: (view.frame.size.width / 2 - 40),
            height: 50)
        buttonDownHumidity.frame = CGRect(
            x: view.frame.size.width / 2 + 20,
            y: view.frame.size.height - 50 - view.safeAreaInsets.bottom,
            width: (view.frame.size.width / 2 - 40),
            height: 50)
        buttonSaveAsPreset.frame = CGRect(
            x: view.frame.size.width / 2 + 20,
            y: view.frame.size.height - 250 - view.safeAreaInsets.bottom,
            width: (view.frame.size.width / 2 - 40),
            height: 50)
    }
    
    
    @objc func didTapButtonLed() {
        if buttonLED.backgroundColor == UIColor.red {
            led(state: "ON")
            buttonLED.backgroundColor = UIColor.green
        } else {
            led(state: "OFF")
            buttonLED.backgroundColor = UIColor.red
        }
    }
    
    @objc func didTapButtonRain() {
        if buttonPrecip.backgroundColor == UIColor.red {
            precip(state: "ON")
            buttonPrecip.backgroundColor = UIColor.green
        } else {
            precip(state: "OFF")
            buttonPrecip.backgroundColor = UIColor.red
        }
    }
    
    @objc func didTapButtonPreOne() {
        led(state: "ON")
        humidity(state: 7)
        temp(state: 85)
        precip(state: "OFF")
        buttonLED.backgroundColor = UIColor.green
        buttonPrecip.backgroundColor = UIColor.red
    }
    
    @objc func didTapButtonUpTemp() {
        ref.child("temp").observeSingleEvent(of: .value, with: {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {
                return
            }
            let currentTemp = val["state"] as! Int
            let newTemp = currentTemp + 1
            self.temp(state: newTemp)
        })
    }
    
    @objc func didTapButtonDownTemp() {
        ref.child("temp").observeSingleEvent(of: .value, with: {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {
                return
            }
            let currentTemp = val["state"] as! Int
            let newTemp = currentTemp - 1
            self.temp(state: newTemp)
        })
    }
    
    @objc func didTapButtonUpHumid() {
        ref.child("humidity").observeSingleEvent(of: .value, with:
                                                    {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {
                return
            }
            let currentHum = val["state"] as! Int
            let newHum = currentHum + 1
            self.humidity(state: newHum)
        })
    }
    
    @objc func didTapButtonDownHumid() {
        ref.child("humidity").observeSingleEvent(of: .value, with:
                                                    {DataSnapshot in
            guard let val = DataSnapshot.value as? NSDictionary else {
                return
            }
            let currentHum = val["state"] as! Int
            let newHum = currentHum - 1
            self.humidity(state: newHum)
        })
    }
        
    // Int Values below
    func temp(state: Int) {
        let post : [String : Int] = ["state": state]
        ref.child("temp").setValue(post)
    }
    
    func humidity(state: Int) {
        let post : [String : Int] = ["state": state]
        ref.child("humidity").setValue(post)
    }
    // ON/OFF below
    func led(state: String) {
        let post : [String: String] = ["state": state]
        ref.child("led").setValue(post)
    }
    
    func precip(state: String) {
        let post : [String: String] = ["state": state]
        ref.child("Rain").setValue(post)
    }
}
