//
//  MainView.swift
//  Landmarks
//
//  Created by Clay Boyd on 2/20/22.
//

import SwiftUI

/*
 Top view of main screen once user is logged in.
 Contains a custom tab bar that conntrols the user view
*/
struct MainView: View {
    @EnvironmentObject var viewModel: AppViewModel
    // ============ View Code =================
    @State private var selectedTab = 2
    @State private var presented = false
    
    let icons = [
        "network",
        "folder",
        "appletvremote.gen1",
        "plus",
        "questionmark.circle"
    ]
    
    @State var posts: [Post] = []
    @State var myPre: [Post] = []
    let cpf = CommunityPresetFunctions()
    
    var body: some View {
        VStack {
            // Content
            ZStack {
                Spacer().fullScreenCover(isPresented: $presented, content: {
                    newPostView()
                    
                })
                
                switch selectedTab {
                    
                case 0:
                    FeedView(posts: posts, cpf: cpf)
                case 1:
                    FavoritesView(posts: myPre, cpf:cpf)
                case 2:
                    ContentView()
                    
                case 3:
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                case 4:
                    AboutView()
                default:
                    ContentView()
                }
                
            }
            .onAppear {
                cpf.observePosts()
                self.posts = cpf.postsList
                self.myPre = viewModel.myPresets
            }

            Spacer()
            //Divider()
            HStack {
                Spacer()
                ForEach(0..<5, id: \.self) { number in
                    Spacer()
                    Button(action: {
                        cpf.observePosts()
                        self.posts = cpf.postsList
                        if number == 3 {
                            presented.toggle()
                        } else {
                            self.selectedTab = number
                        }
                    }) {
                        if number == 2 {
                            Image(systemName: icons[number])
                                .font(.system(size: 25, weight: .regular, design: .default))
                                .foregroundColor(.white)
                                .background(Color(0x4ECB71))
                                .frame(width: 60, height: 60)
                                .background(Color(0x4ECB71))
                                .cornerRadius(30)
                        } else {
                            Image(systemName: icons[number])
                                .font(.system(size: 20, weight: .regular, design: .default))
                                .foregroundColor(selectedTab == number ? Color(0x4ECB71) : Color(UIColor.lightGray))
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
}
        


// preview
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
