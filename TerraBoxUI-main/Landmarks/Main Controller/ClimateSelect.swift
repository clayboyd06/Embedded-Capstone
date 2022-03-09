//
//  ClimateSelect.swift
//  Landmarks
//
//  Created by Oscar Zeng on 1/31/22.
//

import SwiftUI

struct ClimateSelect: View {
    @EnvironmentObject var viewModel: AppViewModel
//    @State private var selection = "Continental"
    @Binding var selection: String
    var climates = ["Demo1234-test", "newDev", "wya", "hello", "demo"]
    
    var body: some View {
        VStack {
            Picker(
                selection: $selection,
                label:
                    Text("rawr")
                ,
                content: {
                    ForEach(climates, id: \.self) { option in

                        HStack {
                            Text(option)
//                            Image(systemName: "heart.fill")
                        }
                        .tag(option)
                    }
                    
                    
                })

                .pickerStyle(MenuPickerStyle())
        }
        .padding(.horizontal)
        .background(.white)
        .cornerRadius(17)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 6)
//        .onAppear {
//            viewModel.getDeviceList()
//        }
    }
}

//struct ClimateSelect_Previews: PreviewProvider {
//    @State private var selection2: String = "Continental"
//    static var previews: some View {
//        ClimateSelect()
//    }
//}
