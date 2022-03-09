//
//  LoginPageView.swift
//  Landmarks
//
//  Created by Clay Boyd on 2/20/22.
//
// Contains the page view for a login page and a sign up page.
// Included in the same file because of structure similarity. 

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

// Login page
struct LoginView: View {
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    @State var errorMsg:String = ""
    
    var body: some View {
        ZStack {
            VStack{
                Image("logowhite")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                
                Text("TerraBox")
                    .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                
                // user textfields
                VStack{
                    TextField("Email Address", text: $email)
                        .padding()
                        .foregroundColor(Color(0x4ECB71))
                        .background(Color(.secondarySystemBackground))
                    // password field is secure
                    SecureField("Password", text: $password)
                        .padding()
                        .foregroundColor(Color(0x4ECB71))
                        .background(Color(.secondarySystemBackground))
                    // validates all fields and
                    // handles the user login via firebase
                    Button(action: {
                        guard !email.isEmpty, !password.isEmpty else {
                            errorMsg = "Fill in all fields"
                            return
                        }
                        
                        viewModel.handleLogin(email: email, pass: password)
                        errorMsg = viewModel.errorMsg
                        print("error \(errorMsg)")
                         //"Error creating account"
                    }, label: {
                        Text("Login")
                            .frame(width: 200, height: 50)
                            .background(Color.white)
                            .foregroundColor(Color(0x4ECB71))
                            .cornerRadius(8)
                    })
                    
                    // takes the user to a new account page
                    NavigationLink("Create Account", destination: SignUpView())
                        .padding()
                        
                }
                .padding()
                
                Text(errorMsg)
                    .foregroundColor(.red)
                    .padding()
                
                Spacer()
            }
            .foregroundColor(.white)
            .background(LinearGradient(colors: [Color(0x4ECB71), Color(0x64FB8E)], startPoint: .top, endPoint: UnitPoint.bottom))
        }
    }
}

// Create account page
struct SignUpView: View {
    @State var username = ""
    @State var email = ""
    @State var password = ""
    
    @State var errorMsg:String = ""
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        ZStack {
            VStack{
                Image("logowhite")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                Text("TerraBox")
                    .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                // user textfields
                VStack{
                    TextField("Username", text: $username)
                        .padding()
                        .foregroundColor(Color(0x4ECB71))
                        .background(Color(.secondarySystemBackground))
                    
                    TextField("Email Address", text: $email)
                        .padding()
                        .foregroundColor(Color(0x4ECB71))
                        .background(Color(.secondarySystemBackground))
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .foregroundColor(Color(0x4ECB71))
                        .background(Color(.secondarySystemBackground))
                    // handles the sign up and logs in the user
                    Button(action: {
                        guard !email.isEmpty, !password.isEmpty else {
                            errorMsg = "Please fill in all fields"
                            return
                        }
                        errorMsg = viewModel.errorMsg
                        viewModel.handleSignUp(username: username, email: email, pass: password)
                    }, label: {
                        Text("Sign Up")
                            .frame(width: 200, height: 50)
                            .background(Color.white)
                            .foregroundColor(Color(0x4ECB71))
                            .cornerRadius(8)
                    })

                        
                }
                .padding()
                // displays any errors for the user 
                Text(errorMsg)
                    .foregroundColor(.red)
                    .padding()
                
                Spacer()
                
            }
            .foregroundColor(.white)
            .background(LinearGradient(colors: [Color(0x4ECB71), Color(0x64FB8E)], startPoint: .top, endPoint: UnitPoint.bottom))
        }
    }
}
