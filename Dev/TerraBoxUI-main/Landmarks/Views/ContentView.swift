//
//  ContentView.swift
//  Landmarks
//
//  Created by Oscar Zeng on 1/29/22.
//
import SwiftUI

struct ContentView: View {
    // Handles logout
    @EnvironmentObject var viewModel: AppViewModel
    
    var screenSize = UIScreen.main.bounds
    
    var deviceIdName = "Demo1234-test"
    
    // For expandableButton
    @State private var showAlert: Bool = true
    @State private var alertLabel: String = ""
    
    @State var selection: String = "Demo1234-test"
    
    // Current status
    @State var waterStatus: CGFloat = 62 // in percent
    @State var humidityStatus: CGFloat = 86 // in percent
    @State var tempStatus: CGFloat = 78 // in F
    @State var lightStatus: CGFloat = 100 // 100 on or 0 off
    // Current settings - while pi is adjusting to desired
    @State var waterSet: CGFloat = 60 // in percent
    @State var humiditySet: CGFloat = 80 // in percent
    @State var tempSet: CGFloat = 77 // in F
    @State var lightSet: CGFloat = 0 // 100 on or 0 off
    
    @State var sprinklerTogg: Bool = false
    @State var heaterTogg: Bool = false
    @State var humidityTogg: Bool = false
    @State var lightTogg: Bool = false
    
    @State var controlTogg: Bool = false
    
    let controlFunctions = FBFunction()
    
    var body: some View {
        ZStack{
            VStack {
                VStack {
                    ZStack {
                        // Title text----------------
                        VStack(alignment: .leading) {
                            // personalize deivce to user
                            Text("\(viewModel.name)'s")
                                .multilineTextAlignment(.leading)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                            Text("TerraBox")
                                .multilineTextAlignment(.leading)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                                .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                        }
                        .padding(.horizontal)
                        .position(x:screenSize.width * 0.25, y:0)
                        
                        
                        // Climate select drop down and Logout
                        VStack(alignment: .leading){
//                            Button(action: {
//                                viewModel.handleLogout()
//                            }) {
//                                Image(systemName: "chevron.left")
//                                    .foregroundColor(.white)
//                                Text("Logout")
//                                    .foregroundColor(.white)
//                            }
//                            .padding(.bottom, 20.0)
//                            .buttonStyle(BorderlessButtonStyle())
                            
                            // on change of selection set viewModel.device to selection
                            ClimateSelect(selection: self.$selection)
                                .padding([.leading, .bottom, .trailing])
                                .padding(.trailing, 30.0)
                                .onChange(of: selection) { sel in print("changed climate")
                                }
                        }
                        .position(x:screenSize.width * 0.85, y:0)

                        Image("Continental")
                            .resizable()
                            .padding()
                            .frame(width: 100, height: 100)
                            .position(x:screenSize.width * 0.5, y:(screenSize.height) * 0.09)
                    }
                }
                
                
                Spacer()
            
                // Status panel sliders----------------
                ZStack {
                    
                    VStack(spacing: -30) {
                        
                        // Water level
                        Icon_Status(width: screenSize.width - 150, percent: self.$waterStatus, colorb: Color(0xC3D7FB), color1: Color(0x92B7F8), color2: Color(0x699BF7), suffix: "%", imageName: "drop.fill"
                        )

                        // Humidity
                        Icon_Status(width: screenSize.width - 150, percent: self.$humidityStatus, colorb: Color(0xB9FFCD), color1: Color(0x84F2A3), color2: Color(0x55B87E), suffix: "%", imageName: "humidity.fill")

                        // Temperature
                        Icon_Status(width: screenSize.width - 150, percent: self.$tempStatus, colorb: Color(0xFFD4BC), color1: Color(0xFFB58D), color2: Color(0xFF9A62), suffix: "F", imageName: "thermometer")

                        // Light
                        Icon_Status(width: screenSize.width - 150, percent: self.$lightStatus, colorb: Color(0xE0AEFF), color1: Color(0xE0AEFF), color2: Color(0xD99BFF), suffix: "", imageName: "lightbulb.fill")

                        HStack {
                            Spacer()
                            
                            Button(action: {
                                // READ FROM DATABASE AND UPDATE FUNCTIONS
                                // Call database functions and update here!!!
                                controlFunctions.getValues(deviceID: selection)
                                
                                self.waterStatus = CGFloat(controlFunctions.water_stat)
                                self.humidityStatus = CGFloat(controlFunctions.humidity_readings)
                                self.tempStatus = CGFloat(controlFunctions.temperature_readings)
                                self.lightStatus = CGFloat(controlFunctions.light_active) != 0 ? 100 : 0
                                
                                self.humiditySet = CGFloat(controlFunctions.targetHum)
                                self.waterSet = CGFloat(controlFunctions.sprink_min)
                                self.lightSet = CGFloat(controlFunctions.light_min)
                                self.tempSet = CGFloat(controlFunctions.targetTemp)
                                
                                print("refreshing status!")
                                
                            }) {
                                Text("Refresh status")
                                    .foregroundColor(Color.blue)
                                    .padding(.top, 6.0)
                                    .font(.system(size: 12))
                                Image(systemName: "arrow.triangle.2.circlepath")
                            }
                            .padding([.top, .leading], 4.0)
                        }
                    }
                    .padding(.all, 10)
                    .background(.white)
                    .cornerRadius(17)
                    .frame(width: screenSize.width - 30, height: 100, alignment: .center)
                    .position(x: screenSize.width / 2, y: (screenSize.height) * 0.08) //
                    .shadow(color: Color.black.opacity(0.4), radius: 3, x: 0, y: 2)
                }
                
                Spacer()
                
                // Control panel and Buttons----------------
                ZStack {
                    VStack {
                        Button(action: {
                            print("hit collapse/expand")
                            
                            controlFunctions.getValues(deviceID: selection)
                            
                            self.humiditySet = CGFloat(controlFunctions.targetHum)
                            self.waterSet = CGFloat(controlFunctions.sprink_min)
                            self.lightSet = CGFloat(controlFunctions.light_min)
                            self.tempSet = CGFloat(controlFunctions.targetTemp)

                            
                            withAnimation{
                                // if all already expanded, collapse all
                                if (self.humidityTogg && self.sprinklerTogg && self.heaterTogg && self.lightTogg || controlTogg) {
                                    self.humidityTogg = false
                                    self.sprinklerTogg = false
                                    self.lightTogg = false
                                    self.heaterTogg = false
                                    self.controlTogg = false
                                }
                                 else { // if "collapsed" then expand all
                                    self.humidityTogg = true
                                    self.sprinklerTogg = true
                                    self.lightTogg = true
                                    self.heaterTogg = true
                                    self.controlTogg = true
                                }

                            }
                        }) {
                            VStack {
                                // rotate chevrons based on controlTogg expanded or collapsed
                                Image(systemName: "chevron.up")
                                    .offset(y:controlTogg ? -3 : 3)
                                    .foregroundColor(Color.white)
                                    .rotationEffect(controlTogg ? Angle(degrees: 180) : Angle(degrees: 0))
                                Image(systemName: "chevron.up")
                                    .foregroundColor(Color.white)
                                    .rotationEffect(controlTogg ? Angle(degrees: 180) : Angle(degrees: 0))
                            }
                        }
                        .zIndex(3)
                        .padding(1.0)
                            
                    HStack(spacing: 0) {
                        VStack(spacing: -15) {
                            Spacer()
                            ExpandableButtonPanel(
                              color1: Color(0xABF4BF), color2: Color(0x57E880),
                              primaryItem: ExpandableButtonItem(label: "Humidity"),
                              secondaryItems: [
                                ExpandableButtonItem(label: "Set: \(self.humiditySet)") {
                                },
                                ExpandableButtonItem(label: "+1") {
                                    controlFunctions.incSetHum(deviceID: selection)
                                    controlFunctions.getValues(deviceID: selection)
                                    self.humiditySet = self.humiditySet + 1
                                },
                                ExpandableButtonItem(label: "-1") {
                                    controlFunctions.decSetHum(deviceID: selection)
                                    controlFunctions.getValues(deviceID: selection)
                                    if self.humiditySet >= 1 {
                                        self.humiditySet = self.humiditySet - 1
                                    }
                                }
                              ],
                              isExpanded: self.$humidityTogg
                            )
                            .padding(.all, 20)
                            Spacer()
                            ExpandableButtonPanel(
                              color1: Color(0xB0CAFA), color2: Color(0x699BF7),
                              primaryItem: ExpandableButtonItem(label: "Sprinkler"),
                              secondaryItems: [
                                ExpandableButtonItem(label: "Set: \(self.waterSet)m") {
                                },
                                ExpandableButtonItem(label: "+1 Min") {
                                    controlFunctions.incSetRain(deviceID: selection)
                                    controlFunctions.getValues(deviceID: selection)
                                    self.waterSet = self.waterSet + 1
                                },
                                ExpandableButtonItem(label: "-1 Min") {
                                    controlFunctions.decSetRain(deviceID: selection)
                                    controlFunctions.getValues(deviceID: selection)
                                    if self.waterSet >= 1 {
                                        self.waterSet = self.waterSet - 1
                                    }
                                    
                                },
                              ],
                              isExpanded: self.$sprinklerTogg
                            )
                            .padding(.all, 20)
                            
                            Spacer()
                        }
                        
                        VStack(spacing: -15){
                            
                            Spacer()
                            ExpandableButtonPanel(
                              color1: Color(0xFFCBAE), color2: Color(0xFF9D68),
                              primaryItem: ExpandableButtonItem(label: "Temperature"),
                              secondaryItems: [
                                ExpandableButtonItem(label: "Set: \(self.tempSet)") {
                                },
                                ExpandableButtonItem(label: "+1") {
                                    controlFunctions.incSetTemp(deviceID: selection)
                                    controlFunctions.getValues(deviceID: selection)
                                    self.tempSet = self.tempSet + 1
                                },
                                ExpandableButtonItem(label: "-1") {
                                    controlFunctions.decSetTemp(deviceID: selection)
                                    controlFunctions.getValues(deviceID: selection)
                                    if self.tempSet >= 1.0 {
                                        self.tempSet = self.tempSet - 1
                                    }
                                }
                              ],
                              isExpanded: self.$heaterTogg
                            )
                            .padding(.all, 20)
                            Spacer()
                            ExpandableButtonPanel(
                              color1: Color(0xE8CDFF), color2: Color(0xD99CFF),
                              primaryItem: ExpandableButtonItem(label: "Light"),
                              secondaryItems: [
                                ExpandableButtonItem(label: "Set: \(self.lightSet)m") {
                                },
                                ExpandableButtonItem(label: "+1 Min") {                                    controlFunctions.incSetLight(deviceID: selection)
                                    controlFunctions.getValues(deviceID: selection)
                                    self.lightSet = self.lightSet + 1
                                },
                                ExpandableButtonItem(label: "-1 Min") {
                                    controlFunctions.decSetLight(deviceID: selection)
                                    controlFunctions.getValues(deviceID: selection)
                                    if self.lightSet >= 1 {
                                        self.lightSet = self.lightSet - 1
                                    }
                                },
                              ],
                              isExpanded: self.$lightTogg
                            )
                            .padding(.all, 20)
                            Spacer()
                        }
                    }
                    .padding(.all, 10)
                    .background(.white)
                    .cornerRadius(17)
                    .frame(width: screenSize.width - 30, alignment: .trailing)
                    .shadow(color: Color.black.opacity(0.4), radius: 3, x: 0, y: 2)
                    }
                    
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(colors: [Color(0x4ECB71), Color(0x64FB8E)], startPoint: .top, endPoint: UnitPoint.bottom)
            )
        }.onAppear {
            viewModel.device = selection
            
            controlFunctions.getValues(deviceID: selection)
            self.waterStatus = CGFloat(controlFunctions.water_stat)
            self.humidityStatus = CGFloat(controlFunctions.humidity_readings)
            self.tempStatus = CGFloat(controlFunctions.temperature_readings)
            self.lightStatus = CGFloat(controlFunctions.light_active) != 0 ? 100 : 0
            self.humiditySet = CGFloat(controlFunctions.targetHum)
            self.waterSet = CGFloat(controlFunctions.sprink_min)
            self.lightSet = CGFloat(controlFunctions.light_min)
            self.tempSet = CGFloat(controlFunctions.targetTemp)
            
            print("loaded")
            print(controlFunctions.targetHum)
        }
        
        
    }
}


extension Color {
    init(_ hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}
