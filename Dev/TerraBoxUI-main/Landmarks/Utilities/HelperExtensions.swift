//
//  HelperExtensions.swift
//  Landmarks
//
//  Created by Clay Boyd on 3/1/22.
//

import Foundation
import SwiftUI

/*
 Allows posts to display the time that has elapsed since a post has been creaeated
 @return String - the time elapsed in a readable format
 */
extension Date {
    func calendarTimeSinceNow() -> String {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        
        let years = components.year!
        let months = components.month!
        let days = components.day!
        let hours = components.hour!
        let minutes = components.minute!
        let seconds = components.second!
        
        if years > 0 {
            return years == 1 ? "1 year ago" : "\(years)y"
        } else if months > 0 {
            return months == 1 ? "1 month ago" : "\(months)mo"
        } else if days >= 7 {
            let weeks = days / 7
            return weeks == 1 ? "1 week ago" : "\(weeks)w"
        } else if days > 0 {
            return days == 1 ? "1 day ago" : "\(days)d"
        } else if hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours)h"
        } else if minutes > 0 {
            return minutes == 1 ? "1 minute ago" : "\(minutes)m"
        } else {
            return seconds == 1 ? "1 second ago" : "\(seconds)s"
        }
    }
}

/*
 String message to display on the about view
 */
struct About {
    static var message:String = """
    TerraBox makes climate control easy, so that you
    can enjoy the benefits of exotic plants and animals
    in any environment. Usage is simple:
        1) Place your TerraBox wherever you please!
        2) Pair your device by entering the device id
            included with the TerraBox
            into the main controller page, or by
            selecting it from the dropdown menu
            if you have multiple devices.
        3) Manually control the conditions
            via the main controller, or select a
            preset from the system presets menu,
            or from the community presets feed.
        4) Create your own presets! Feel free
            to include a description and title,
            and you can publish your own
            presets to the community!
    
    Visit www.TBForum.com/ for more information or to connect with one of our representatives.
    
    Thank you for using TerraBox.
    """
}
