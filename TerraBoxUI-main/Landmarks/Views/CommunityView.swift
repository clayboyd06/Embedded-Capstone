//
//  CommunityView.swift
//  Landmarks
//
//  Created by Clay Boyd on 2/17/22.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

// Main feed for community preset items
struct FeedView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    @State var localPosts: [Post] = []
    let posts: [Post]
    let cpf: CommunityPresetFunctions
    
    var body: some View {
        ZStack {
            List(localPosts) { post in
                PostView(post: post, deviceID: viewModel.device)
            }
            .listStyle(PlainListStyle())
            .navigationBarItems(leading: Button(action: {
                viewModel.handleLogout()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color(0x4ECB71))
                Text("Logout")
                    .foregroundColor(Color(0x4ECB71))
            }, trailing: Button(action: {
                cpf.observePosts()
                self.localPosts = cpf.postsList.sorted(by: {$0.timeStamp > $1.timeStamp})
                }) {
                Image(systemName: "arrow.triangle.2.circlepath")}
                                    .foregroundColor(Color(0x4ECB71))
            )
        }
        .onAppear {
            self.localPosts = posts.sorted(by: {$0.timeStamp > $1.timeStamp})
            print("Posts:  \(self.localPosts)")
            print()
        }
    }
}

// View for all the posts the user favorites
struct FavoritesView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    @State var localPosts: [Post] = []
    let posts: [Post]
    let cpf: CommunityPresetFunctions
    
    var body: some View {
        ZStack {
            List(localPosts) { post in
                SystemPresetView(post: post, deviceID: viewModel.device)
            }
            .listStyle(PlainListStyle())
            .navigationBarItems(leading: Button(action: {
                viewModel.handleLogout()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color(0x4ECB71))
                Text("Logout")
                    .foregroundColor(Color(0x4ECB71))
            }, trailing: Button(action: {
                cpf.observePosts()
                self.localPosts = viewModel.myPresets.sorted(by: {$0.timeStamp > $1.timeStamp})
                }) {
                Image(systemName: "arrow.triangle.2.circlepath")}
                                    .foregroundColor(Color(0x4ECB71))
            )
        }
        .onAppear {
            self.localPosts = posts.sorted(by: {$0.timeStamp > $1.timeStamp})
            print("Posts:  \(self.localPosts)")
            print()
        }
    }
}


// Organizes the information for a single community preset post
//
// Includes: Author, timestamp
// Short description
// The list of values that it sends to firebase upon button press
// Includes actions for each post:
// favorite, and set the preset for own device
struct PostView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    let post: Post
    let darkGreen = Color(0x006400)
    
    @State private var didTapLike: Bool = false
    @State private var didTapTry: Bool = false
    @State private var likes: Int = 0
    @State private var trials: Int = 0
    // change to read the selection
    let deviceID: String //viewModel.device //"Demo1234-test"
    
    
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(post.title)
                            .font(.system(size: 20, weight: .regular, design: .default))
                            .bold()
                            .lineLimit(1)
                        Text("\(post.authorName) • \(post.createdAt)")
                            .lineLimit(1)
                            .truncationMode(.middle)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 1)
                    
                    Text(post.description)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    //Divider()
                    Spacer()
                    Text("Settings:")
                        .font(.system(size: 20, weight: .regular, design: .default))
                    //
                    HStack (alignment: .top) {
                        VStack (alignment: .leading) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .font(.system(size: 22, weight: .regular, design: .default))
                                    .foregroundColor(Color(0xE0AEFF))
                                VStack(alignment: .leading){
                                    Text("\(post.light_hour) hour")
                                        .font(.system(size: 15, weight: .regular, design: .default))
                                    Text("\(post.light_min) min")
                                        .font(.system(size: 15, weight: .regular, design: .default))
                                }
                                                                
                            }

                            Spacer()
                            HStack {
                                Image(systemName: "humidity.fill")
                                    .font(.system(size: 22, weight: .regular, design: .default))
                                    .foregroundColor(Color(0x4ECB71))
                                Text("\(post.humidity) %")
                                    .font(.system(size: 15, weight: .regular, design: .default))
                                
                            }
                        }
                        
                        VStack(alignment: .center) {
                            Text("|")
                                .font(.system(size: 22, weight: .regular, design: .default))
                                .foregroundColor(.gray)
                            Spacer()
                            Text("|")
                                .font(.system(size: 22, weight: .regular, design: .default))
                                .foregroundColor(.gray)
                        }
                        
                        VStack (alignment: .leading) {
                            HStack {
                                Image(systemName: "drop.fill")
                                    .font(.system(size: 22, weight: .regular, design: .default))
                                    .foregroundColor(Color(0x92B7F8))
                                
                                VStack(alignment: .leading){
                                    Text("\(post.sprinkler_hour) hour")
                                        .font(.system(size: 15, weight: .regular, design: .default))
                                    Text("\(post.sprinkler_min) min")
                                        .font(.system(size: 15, weight: .regular, design: .default))
                                }

                            }
                            Spacer()
                            HStack {
                                Image(systemName: "thermometer")
                                    .font(.system(size: 22, weight: .regular, design: .default))
                                    .foregroundColor(Color(0xFFB58D))
                                Text(" \(post.temp) ºF")
                                    .font(.system(size: 15, weight: .regular, design: .default))

                            }
                        }
                    }
                    /// ===============
                    Divider()
                    HStack {
                        Spacer()
                        // like preset button
                        Button(action: {
                            // add this post to liked posts
                            self.didTapLike.toggle()
                            if self.didTapLike == true {
                                // avoids duplicates from liking
                                let tempList = viewModel.myPresets.filter { $0.id != post.id }
                                viewModel.myPresets = tempList
                                viewModel.myPresets.insert(post, at: 0)
                                post.addLike()
                            } else {
                                let tempList = viewModel.myPresets.filter { $0.id != post.id }
                                viewModel.myPresets = tempList
                                post.removeLike()
                            }
                        }) {
                            HStack {
                                Text("Add to favorites")
                                    .foregroundColor(didTapLike ? Color(0x4ECB71) : .gray)
                                Image(systemName: "star")
                                    .foregroundColor(didTapLike ? Color(0x4ECB71) : .gray)
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Text(post.numberOfLikes > 0 ? "\(post.numberOfLikes)" : "")
                            .foregroundColor(.gray)
                        
                        Spacer()
                        Divider()
                        Spacer()
                        // Use preset button
                        Button(action: {
                            self.didTapTry = true
                            post.addTrial()
                            CommunityPresetFunctions.useCommunityPreset(devID: deviceID, post: post)
                            
                        }) {
                            HStack {
                                Text("Use Preset")
                                    .foregroundColor(didTapTry ? Color(0x4ECB71) : .gray)
                                Image(systemName: "square.and.arrow.down")
                                    .foregroundColor(didTapTry ? Color(0x4ECB71) : .gray)
                            }

                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Text(post.numberOfTrials > 0 ? "\(post.numberOfTrials)" : "")
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                }
            }
        }
        .cornerRadius(3)
    }
}

// Organizes the information for a single community preset post
//
// Includes: Author,
// Short description
// The list of values that it sends to firebase upon button press
// Includes actions for each post:
// remove favorite, and set the preset for own device
struct SystemPresetView: View {
    @EnvironmentObject var viewModel: AppViewModel
    let post: Post
    let darkGreen = Color(0x006400)
    
    @State private var didTapLike: Bool = true
    @State private var didTapTry: Bool = false
    // change to read the selection
    let deviceID:String // = "Demo1234-test"
    
    
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(post.title)
                            .font(.system(size: 20, weight: .regular, design: .default))
                            .bold()
                            .lineLimit(1)
                        Text("\(post.authorName)")
                            .lineLimit(1)
                            .truncationMode(.middle)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 1)
                    
                    Text(post.description)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Divider()
                    Spacer()
                    Text("Settings:")
                        .font(.system(size: 20, weight: .regular, design: .default))
                    HStack (alignment: .top) {
                        VStack (alignment: .leading) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .font(.system(size: 22, weight: .regular, design: .default))
                                    .foregroundColor(Color(0xE0AEFF))
                                VStack(alignment: .leading){
                                    Text("\(post.light_hour) hours")
                                        .font(.system(size: 15, weight: .regular, design: .default))
                                    Text("\(post.light_min) minutes")
                                        .font(.system(size: 15, weight: .regular, design: .default))
                                }
                                                                
                            }
                            Spacer()
                        
                            HStack {
                                Image(systemName: "humidity.fill")
                                    .font(.system(size: 22, weight: .regular, design: .default))
                                    .foregroundColor(Color(0x4ECB71))
                                Text("\(post.humidity) %")
                                    .font(.system(size: 15, weight: .regular, design: .default))
                                
                            }
                        }
                        
                        VStack(alignment: .center) {
                            Text("|")
                                .font(.system(size: 22, weight: .regular, design: .default))
                                .foregroundColor(.gray)
                            Spacer()
                            Text("|")
                                .font(.system(size: 22, weight: .regular, design: .default))
                                .foregroundColor(.gray)
                        }
                        
                        VStack (alignment: .leading) {
                            HStack {
                                Image(systemName: "drop.fill")
                                    .font(.system(size: 22, weight: .regular, design: .default))
                                    .foregroundColor(Color(0x92B7F8))
                                
                                VStack(alignment: .leading){
                                    Text("\(post.sprinkler_hour) hours")
                                        .font(.system(size: 15, weight: .regular, design: .default))
                                    Text("\(post.sprinkler_min) minutes")
                                        .font(.system(size: 15, weight: .regular, design: .default))
                                }

                            }
                            
                            Spacer()
                            
                            HStack {
                                Image(systemName: "thermometer")
                                    .font(.system(size: 22, weight: .regular, design: .default))
                                    .foregroundColor(Color(0xFFB58D))
                                Text(" \(post.temp) ºF")
                                    .font(.system(size: 15, weight: .regular, design: .default))

                            }
                        }
                    }
                    Divider()
                    HStack {
                        Spacer()
                        Button(action: {
                            // add this post to liked posts
                            self.didTapLike = false
                            let tempList = viewModel.myPresets.filter { $0.id != post.id }
                            viewModel.myPresets = tempList
                        }) {
                            HStack {
                                Text("Remove preset")
                                    .foregroundColor(didTapLike ? Color(0x4ECB71) : .gray)
                                Image(systemName: "star.slash")
                                    .foregroundColor(didTapLike ? Color(0x4ECB71) : .gray)
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Text(post.numberOfLikes > 0 ? "\(post.numberOfLikes)" : "")
                            .foregroundColor(.gray)
                        
                        Spacer()
                        Divider()
                        Spacer()
                        
                        Button(action: {
                            self.didTapTry = true
                            print("Post updating...")
                            CommunityPresetFunctions.useCommunityPreset(devID: deviceID, post: post)
                            
                        }) {
                            HStack {
                                Text("Use preset")
                                    .foregroundColor(didTapTry ? Color(0x4ECB71) : .gray)
                                Image(systemName: "square.and.arrow.down")
                                    .foregroundColor(didTapTry ? Color(0x4ECB71) : .gray)
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                    }
                }
            }
        }
        .cornerRadius(3)
    }
}
