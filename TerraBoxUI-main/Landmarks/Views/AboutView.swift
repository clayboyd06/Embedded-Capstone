//
//  AboutView.swift
//  Landmarks
//
//  Created by Clay Boyd on 3/1/22.
//
import SwiftUI

/*
 Informational page including instructions for use,
 and a thank you message
 */
struct AboutView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        ZStack {
            VStack{
                HStack {
                    Spacer()
                    Image("logogreen")
                        .resizable()
                        .frame(width: 70, height: 70)
                    Spacer()
                }

                ScrollView {
                    Text(About.message)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}
                        

