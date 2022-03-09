//
//  ControlButton.swift
//  Landmarks
//
//  Created by Oscar Zeng on 1/29/22.
//
import SwiftUI

struct ControlButton: View {
    var name = "Sprinkler"
    var color1 = Color(0xB0CAFA)
    var color2 = Color(0x699BF7)
    var textcolor = Color.white

    
    var body: some View {
        Button("\(name)", action: {
            print("button clicked")
        })
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 15
        )
        .padding()
        .foregroundColor(textcolor)
        .background(
            LinearGradient(
                colors: [color1, color2], startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(17)
    }
}

struct ControlButton_Previews: PreviewProvider {
    static var previews: some View {
        ControlButton()
    }
}
