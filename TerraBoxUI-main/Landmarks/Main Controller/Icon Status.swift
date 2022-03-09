//
//  Icon Status.swift
//  Landmarks
//
//  Created by stlp on 1/29/22.
//

import SwiftUI

struct Icon_Status: View {
    var width: CGFloat = 300
    var height: CGFloat = 45
//    var percent: CGFloat = 25
    @Binding var percent: CGFloat
    var colorb = Color(0xC3D7FB)
    var color1 = Color(0xB0CAFA)
    var color2 = Color(0x699BF7)
    var suffix = "%"
    var imageName = "thermometer"
    var body: some View {
        HStack() {
            
            Spacer()
            
            Image(systemName: imageName)
                .font(.title)
                .foregroundColor(color2)

            Spacer()
            
            Slider_bar(width: width, height: height, percent: percent, colorb: colorb, color1: color1, color2: color2, suffix: suffix)
                .animation(.spring())
                
        }
        

    }
}

struct Icon_Status_Prev: View {
    @State private var percenty: CGFloat = 72
    
    var body: some View {
        Icon_Status(percent: self.$percenty)
    }
}

struct Icon_Status_Previews: PreviewProvider {
    
    static var previews: some View {
        Icon_Status_Prev()
    }
}
