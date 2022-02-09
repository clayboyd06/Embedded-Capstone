//
//  deviceInfo.swift
//  Terrabox
//
//  Created by Clay Boyd on 2/7/22.
//

import Foundation

class DeviceInfo {
    var id: String
    var activate_lights: Int
    var activate_sprinklers: Int
    var target_temp: Int
    var target_humidity: Int
    
    init(id: String, activate_lights: Int, activate_sprinklers: Int, target_temp: Int, target_humidity: Int) {
        self.id = id
        self.activate_lights = activate_lights
        self.activate_sprinklers = activate_sprinklers
        self.target_temp = target_temp
        self.target_humidity = target_humidity
    }
}
