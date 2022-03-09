//
//  LandmarksApp.swift
//  Landmarks
//
//  Created by stlp on 1/29/22.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseAuth

@main
struct LandmarksApp: App {
    
    // declares the delegate variabele
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    
    var body: some Scene {
        WindowGroup {
            let viewModel = AppViewModel()
            InitialView()
                .environmentObject(viewModel)
        }
    }
}

// extends UIApplicationDelegate to respond to NS object
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//  var window: UIWindow?
//
//  func application(_ application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions:
//      [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//    FirebaseApp.configure()
//
//    return true
//  }
//}
