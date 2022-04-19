//
//  AuthHandler.swift
//  Landmarks
//
//  Created by Clay Boyd on 2/16/22.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase


// Contains a set of functions to handle user sign in and sign out
// in firebase
class AppViewModel: ObservableObject {
    let ref = Database.database().reference()
    let auth = Auth.auth()
    
    @Published var signedIn = false
    // returns true if the user is currently logged in
    var isLoggedIn: Bool {
        return auth.currentUser != nil
    }
    
    var device:String = "Demo1234-test"
    
    var uid: String {
        guard let uid = auth.currentUser?.uid else {return ""}
        return uid
    }
    
    var name: String {
        guard let name = auth.currentUser?.displayName else {return ""}
        return name
    }
    
    var errorMsg:String = ""
    
    
    // List of presets unique to each user 
    var myPresets: [Post] = [
        Post(id: UUID().uuidString, authorName: "System", timeStampText: 0 ,authID: "0", title: "Tropical", description: "Characterized by average temperatures of 80°F, a wet season an a dry season. Near the equator the light is fairly consistent", numberOfLikes: 0, numberOfTrials: 0, lights: 0, sprinklers: 0, humidity: 40, temp: 80, light_hour: 8, light_min: 15, sprinkler_days: 1, sprinkler_hour: 7, sprinkler_min: 30),
        
        Post(id: UUID().uuidString, authorName: "System", timeStampText: 0,authID: "0", title: "Dry", description: "Characterized by low precipitation. The temperature is fairly temperate with consistent light.", numberOfLikes: 0, numberOfTrials: 0, lights: 1, sprinklers: 0, humidity: 0, temp: 70, light_hour: 10, light_min: 0, sprinkler_days: 15, sprinkler_hour: 1, sprinkler_min: 30),
        
        Post(id: UUID().uuidString, authorName: "System", timeStampText: 0,authID: "0", title: "Temperate", description: "Characterized by consistent but not overwhelming precipitation, low humidity, and a temperature of 50°F on average", numberOfLikes: 0, numberOfTrials: 0, lights: 0, sprinklers: 0, humidity: 2, temp: 50, light_hour: 11, light_min: 30, sprinkler_days: 3, sprinkler_hour: 2, sprinkler_min: 1),
        
        Post(id: UUID().uuidString, authorName: "System", timeStampText: 0,authID: "0", title: "Continental", description: "Characterized as wet and cold. The average temperature is 50°F, with low rainfall. The light is on for longer due to the long day cycles", numberOfLikes: 0, numberOfTrials: 0, lights: 1, sprinklers: 1, humidity: 0, temp: 50, light_hour: 18, light_min: 0, sprinkler_days: 4, sprinkler_hour: 1, sprinkler_min: 30),
        
        // ========= Demo Posts ==========
        Post(id: UUID().uuidString, authorName: "System", timeStampText: 0,authID: "0", title: "DEMO1", description: "Sprinkler only", numberOfLikes: 0, numberOfTrials: 0, lights: 1, sprinklers: 1, humidity: 20, temp: 70, light_hour: 0, light_min: 0, sprinkler_days: 0, sprinkler_hour: 0, sprinkler_min: 0, light_sec: 0, sprinkler_sec: 30),
        
        Post(id: UUID().uuidString, authorName: "System", timeStampText: 0,authID: "0", title: "DEMO2", description: "Light only", numberOfLikes: 0, numberOfTrials: 0, lights: 1, sprinklers: 1, humidity: 20, temp: 70, light_hour: 0, light_min: 0, sprinkler_days: 0, sprinkler_hour: 1, sprinkler_min: 0, light_sec: 30, sprinkler_sec: 0),
        
        Post(id: UUID().uuidString, authorName: "System", timeStampText: 0,authID: "0", title: "DEMO3", description: "Light and sprinkler", numberOfLikes: 0, numberOfTrials: 0, lights: 1, sprinklers: 1, humidity: 20, temp: 70, light_hour: 0, light_min: 0, sprinkler_days: 0, sprinkler_hour: 0, sprinkler_min: 0, light_sec: 30, sprinkler_sec: 30),
        
        Post(id: UUID().uuidString, authorName: "System", timeStampText: 0,authID: "0", title: "DEMO3", description: "No light, no sprinkler, high humidity", numberOfLikes: 0, numberOfTrials: 0, lights: 1, sprinklers: 1, humidity: 90, temp: 70, light_hour: 0, light_min: 0, sprinkler_days: 0, sprinkler_hour: 0, sprinkler_min: 0, light_sec: 0, sprinkler_sec: 30),
        
        Post(id: UUID().uuidString, authorName: "System", timeStampText: 0,authID: "0", title: "DEMO3", description: "No light and sprinkler, low humidity, high temp", numberOfLikes: 0, numberOfTrials: 0, lights: 0, sprinklers: 0, humidity: 5, temp: 100, light_hour: 0, light_min: 0, sprinkler_days: 1, sprinkler_hour: 1, sprinkler_min: 0, light_sec: 0, sprinkler_sec: 30),
    ]
    
    
    // adds the preset to the favorites list
    func addPreset(preset: Post) {
        let postInfo = [
            "authID": preset.authID,
            "author": preset.authorName,
            "timeStamp": preset.timeStamp,
            "title": preset.title,
            "description": preset.description,
            "likes": preset.numberOfLikes,
            "trials": preset.numberOfTrials
        ] as [String:Any]
        
        let postSendback = ["activate_lights": preset.lights,
                            "activate_sprinklers": preset.sprinklers,
                            "target_humidity": preset.humidity,
                            "target_temp": preset.temp,
                            "light_time": ["hour": preset.light_hour,
                                           "minute": preset.light_min,
                                           "second": preset.light_seconds],
                            "sprinkler_time": ["day": preset.sprinkler_days,
                                               "hour": preset.sprinkler_hour,
                                              "minute": preset.sprinkler_min,
                                              "second": preset.sprinker_sec]
            ] as [String : Any]

        ref.child("users").child(self.uid).child("myPresets").child(preset.id).child("postInfo").setValue(postInfo)
        ref.child("users").child(self.uid).child("myPresets").child(preset.id).child("postSendback").setValue(postSendback)
        //}
    }
    
    
    // reads all of the community posts in the database, ordered by timestamp and
    // appends them to a list
    func observePosts() {
        let quearyRef = ref.child("users").child(self.uid).child("myPresets").queryOrdered(byChild: "timeStamp").queryLimited(toLast: 20)
        quearyRef.observe(.value, with: { DataSnapshot in
            var tempPosts = [Post]()
            
            for child in DataSnapshot.children {
                print("made it this far")
                guard let childSnap = child as? DataSnapshot else {return}
                print("child did exist")
                guard let id = childSnap.key as? String else {return}
                guard let dict = childSnap.value as? [String: Any] else {return}
                print("hi")
                // post info
                guard let postinfo = dict["postInfo"] as? [String: Any] else {return}
                print("post info \(postinfo)")
                let authID = postinfo["authID"] as? String
                let author = postinfo["author"] as? String
                let timeStamp = postinfo["timeStamp"] as? Double
                let title = postinfo["title"] as? String
                let desc = postinfo["description"] as? String
                let likes = postinfo["likes"] as? Int
                let trials = postinfo["trials"] as? Int
                print("going to sendback")
                // controller values
                guard let val = dict["postSendback"] as? [String: Any] else {return}
                print("Val \(val)")
                let targetHum = val["target_humidity"] as? Int
                let targetTemp = val["target_temp"] as? Int
                let actLights = val["activate_lights"] as? Int
                let actSprink = val["activate_sprinklers"] as? Int
                print("going to light_")
                guard let light_time = val["light_time"] as? [String:Any] else {return}
                print("made it")
                let light_h = light_time["hour"] as? Int
                let light_min = light_time["minute"] as? Int
                //let light_sec = light_time["second"] as? Int
                
                guard let sprinkler_time = val["sprinkler_time"] as? [String: Any] else {return}
                print("made it")
                let sprinkler_days = sprinkler_time["day"] as? Int
                let sprinkler_h = sprinkler_time["hour"] as? Int
                let sprinkler_min = sprinkler_time["sec"] as? Int
                //let sprinkler_s = sprinkler_time["day"] as? Int
                
                
                let post = Post(id: id, authorName: author ?? "", timeStampText: timeStamp ?? 0 , authID: authID ?? "", title: title ?? "", description: desc ?? "desc", numberOfLikes: likes ?? 0, numberOfTrials: trials ?? 0, lights: actLights ?? 0, sprinklers: actSprink ?? 0, humidity: targetHum ?? 20, temp: targetTemp ?? 20, light_hour: light_h ?? 0, light_min: light_min ?? 0, sprinkler_days: sprinkler_days ?? 0, sprinkler_hour: sprinkler_h ?? 0, sprinkler_min: sprinkler_min ?? 0)
                
                if post.authorName !=  "" && post.authID != "" && post.title != "" && post.description  != "" {
                    tempPosts.insert(post, at: 0)
                }
                
                print("post added!")
            }
            self.myPresets = tempPosts
            print("temp \(tempPosts) post list \(self.myPresets)")
            //print(self.postsList)
        })
    }
    
    /*
    When the login button is tapped, checks that the fields are all filled in
     goes to home screen. Displays an error message if there is an error
     @param email - the entered email
     @param pass - the entered password
     */
    func handleLogin(email: String, pass: String){
        auth.signIn(withEmail: email, password: pass) { [weak self] user, err in
            if user == nil || err != nil  {
                self?.errorMsg = "Invalid Login"
                return
            } else {
                self?.errorMsg = ""
                DispatchQueue.main.async {
                    self?.signedIn = true
                }
            }
        }
    }
    /*
    When sign up is tapped, checks that all fields are filled in
    creates a new user, updates the user profile in the real time database and
    goes to home screen
     @param username- the inputted username by the user
     @param email - the inputted email by the user
     @param pass - the user inputted password
     */
    func handleSignUp(username: String, email: String, pass: String) {
        auth.createUser(withEmail: email, password: pass) { [weak self] user, err in
            if user == nil || err != nil  {
                self?.errorMsg = "Error creating account"
                return
            } else {
                self?.errorMsg = ""
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                changeRequest?.displayName = username
                                changeRequest?.commitChanges { error in
                                    if error == nil {
                                        Auth.auth().signIn(withEmail: email, password: pass)
                                        let uid = Auth.auth().currentUser!.uid
                                        self?.newUserPost(uid: uid, user: username, email: email, password: pass, deviceList: ["No devices"], presetList: self!.myPresets)
                                    }
                                }
                
                DispatchQueue.main.async {
                    self?.signedIn = true
                }
            }
        }
    }
    
    /*
     creates a new database post for the user with a list of information associated with each user
     @param uid - the id generated by the database associated with each user
     @param user- the inputted username by the user
     @param email - the inputted email by the user
     @param password - the user inputted password
     @param deviceList - a list of all the devices associated with a user
     @param presetList - a list of all of the presets that the user has favorited
     */
    func newUserPost(uid: String, user: String, email: String, password: String, deviceList: [String], presetList: [Post]) {
        let post : [String: Any] = ["user": user, "email" : email, "password": password, "devices": deviceList, "myPresets": presetList]
        self.ref.child("users").child(uid).setValue(post)
    }
    
    // signs out and sets the state to signed out 
    func handleLogout() {
        try! self.auth.signOut()
        DispatchQueue.main.async {
            self.signedIn = false
        }
    }
}
