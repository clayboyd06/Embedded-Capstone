//
//  Slider bar.swift
//  Landmarks
//
//  Created by Oscar Zeng on 1/29/22.
//

import SwiftUI

struct Slider_bar: View {
    var width: CGFloat = 300
    var height: CGFloat = 45
    var percent: CGFloat = 10
    var colorb = Color(0xC3D7FB)
    var color1 = Color(0xB0CAFA)
    var color2 = Color(0x699BF7)
    var suffix = "%"
    
    var body: some View {
        let multiplier = percent / 100
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: width, height: height)
                .foregroundColor(colorb)
            
            // only leading works ok, using center or trailing is scuffed at lower percentages (<25)
            ZStack(alignment: .leading ){
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .frame(width: multiplier * width, height: height)
                    .background(
                        LinearGradient(colors: [color1, color2], startPoint: .leading, endPoint: .trailing)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    )
                    .foregroundColor(.clear)
                    
                
                Text("\(Int(percent)) \(suffix)")
                    .foregroundColor(.white)
                    .padding()
                    
            }


                
                
        }
        .padding()

        
        
    }
}

struct Slider_bar_Previews: PreviewProvider {
    static var previews: some View {
        Slider_bar()
    }
}


