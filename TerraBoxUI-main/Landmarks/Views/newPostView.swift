//
//  newPostView.swift
//  Landmarks
//
//  Created by Clay Boyd on 2/22/22.
//
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

/*
 View of a new post
 Contains textfields for all of the necessary information for a post:
 Title, description, the sendback values for the device
 An option to publish the preset to the community
 And a send button
 */
struct newPostView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var title = ""
    @State var desc = ""
    @State var lights = ""
    @State var sprinklers = ""
    @State var humidity = ""
    @State var temp = ""
    @State var light_hours = 0
    @State var light_min = 0
    
    @State var sprinkler_days = ""
    @State var sprinkler_hour = 0
    @State var sprinkler_min = 0
    
    @State var publishToCommunity = false
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack {
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrowshape.turn.up.left")
                                .padding()
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Text("New Preset")
                            .font(.system(size: 25, weight: .regular, design: .default))
                            .foregroundColor(Color(.secondarySystemBackground))
                            .padding()
                        Spacer()
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        TextField("Title", text: $title)
                            .font(.system(size: 20, weight: .regular, design: .default))
                            .padding()
                            .foregroundColor(Color(0x4ECB71))
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(3)
                            .onTapGesture { self.hideKeyboard() }
                        Spacer()
                    }

                    HStack {
                        Spacer()
                        TextField("Description", text: $desc)
                            .font(.system(size: 15, weight: .regular, design: .default))
                            .frame(height: 70)
                            .padding()
                            .foregroundColor(Color(0x4ECB71))
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(3)
                            .onTapGesture { self.hideKeyboard() }
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        TextField("Humidity (%)", text: $humidity)
                            .font(.system(size: 15, weight: .regular, design: .default))
                            .padding()
                            .foregroundColor(Color(0x4ECB71))
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(3)
                            .onTapGesture { self.hideKeyboard() }
                        TextField("Temperature (ºF)", text: $temp)
                            .font(.system(size: 15, weight: .regular, design: .default))
                            .padding()
                            .foregroundColor(Color(0x4ECB71))
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(3)
                            .onTapGesture { self.hideKeyboard() }
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        TextField("Days between Sprinkler Cycles", text: $sprinkler_days)
                            .font(.system(size: 15, weight: .regular, design: .default))
                            .padding()
                            .foregroundColor(Color(0x4ECB71))
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(3)
                            .onTapGesture { self.hideKeyboard() }
                        Spacer()
                    }
                    .zIndex(2)
                    
                    Group {
                        Divider()
                        Spacer()
                    }
                    
                    VStack {
                        VStack (alignment: .leading){
                            Text("Time between sprinkler cycles")
                                .font(.system(size: 17, weight: .regular, design: .default))
                                .foregroundColor(.white)
                                .cornerRadius(3)
                                .padding([.leading, .trailing])
                            // Sprinkler picker
                            HStack {
                                Spacer()
                                Picker("Sprinkler Hours On", selection: $sprinkler_hour) {
                                    ForEach(0...23, id: \.self) {hour in
                                        Text("\(hour) hours")
                                            .foregroundColor(.white)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: geometry.size.width / 3, height: 50)
                                .clipped()
                                .foregroundColor(.white)
                                
                                Spacer()

                                Picker("Sprinkler Minutes On", selection: $sprinkler_min) {
                                    ForEach(0...59, id: \.self) {min in
                                        Text("\(min) min")
                                            .foregroundColor(.white)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: geometry.size.width / 3, height: 50)
                                .clipped()
                                .foregroundColor(.white)

                                Spacer()
                            }
                            Divider()
                        }
                        
                        VStack (alignment: .leading){
                            Text("Light On Time")
                                .font(.system(size: 17, weight: .regular, design: .default))
                                .foregroundColor(.white)
                                .cornerRadius(3)
                                .padding([.leading, .trailing])
                            // Sprinkler picker
                            HStack {
                                Spacer()
                                Picker("light Hours On", selection: $light_hours) {
                                    ForEach(0...23, id: \.self) {hour in
                                        Text("\(hour) hours")
                                            .foregroundColor(.white)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: geometry.size.width / 3, height: 50)
                                .clipped()
                                .foregroundColor(.white)
                                
                                Spacer()

                                Picker("light Minutes On", selection: $light_min) {
                                    ForEach(0...59, id: \.self) {min in
                                        Text("\(min) min")
                                            .foregroundColor(.white)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: geometry.size.width / 3, height: 50)
                                .clipped()
                                .foregroundColor(.white)

                                Spacer()
                            }
                            Divider()
                        }
                    }
                                                        
                    HStack {
                        Spacer()
                        Toggle(isOn: $publishToCommunity) {
                            Text("Publish as community preset")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .tint(.white)
                    }
                    .zIndex(1)
                    //Formatted button
                    VStack {
                        Spacer()
                        HStack{
                            Spacer()
                            // publish button
                            Button(action: {
                                let lightNum =  0
                                let sprinkNum =  0
                                let humNum = Int(humidity) ?? 0
                                let tempNum = Int(temp) ?? 0
                                let sprink_dnum = Int(sprinkler_days) ?? 0
                                // create Post object
                                let post = Post(id: UUID().uuidString, authorName: viewModel.name, timeStampText: 0.0, authID: viewModel.uid, title: self.title, description: self.desc, numberOfLikes: 0, numberOfTrials: 0, lights: lightNum, sprinklers: sprinkNum, humidity: humNum, temp: tempNum, light_hour: light_hours, light_min: light_min, sprinkler_days: sprink_dnum, sprinkler_hour: sprinkler_hour, sprinkler_min: sprinkler_min)
                                // Send the post to the list of user presets
                                let tempList = viewModel.myPresets.filter { $0.id != post.id }
                                viewModel.myPresets = tempList
                                viewModel.myPresets.insert(post, at: 0)
                                // send to community list
                                if publishToCommunity {
                                    CommunityPresetFunctions.setNewPost(post: post)
                                }
                                // dismiss the newPost view
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "paperplane")
                                    .font(.largeTitle)
                                    .foregroundColor(Color(0x4ECB71))
                                    .padding()
                            }
                            .background(Color(.secondarySystemBackground))
                            .mask(Circle())
                            .shadow(radius: 5)
                            .padding(.bottom, 85)
                            .padding(.trailing)
                        }
                    }
                }
            }
        }
        .background(LinearGradient(colors: [Color(0x4ECB71), Color(0x64FB8E)], startPoint: .top, endPoint: UnitPoint.bottom))
    }
}
// Allows the user to tap anywhere to dismiss the keyboard. 
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
