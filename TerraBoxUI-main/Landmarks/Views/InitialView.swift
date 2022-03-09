//
//  InitialView.swift
//  Landmarks
//
//  Created by Clay Boyd on 2/16/22.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

// Controls the view upon opening the app
struct InitialView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationView {
            // if already signed in goes straight to the main view
            if viewModel.signedIn {
                //ContentView()
                MainView()
            } else {
                LoginView()
            }
            
        }
        .onAppear{
            viewModel.signedIn = viewModel.isLoggedIn
        }
    }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}
