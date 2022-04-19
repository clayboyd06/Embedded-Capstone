//
//  communityPresetsUtils.swift
//  Landmarks
//
//  Created by Clay Boyd on 2/20/22.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

// Creates a community preset object with all the needed information
// to set a terrabox climate + title and author
class Post: Identifiable {
    var id: String
    var authorName: String
    var timeStamp: Double
    var createdAt: String
    var authID: String
    var title: String
    var description: String
    var numberOfLikes: Int
    var numberOfTrials: Int
    
    var lights: Int
    var sprinklers: Int
    var humidity: Int
    var temp: Int
    var light_hour: Int
    var light_min: Int
    var light_seconds: Int
    var sprinkler_days: Int
    var sprinkler_hour: Int
    var sprinkler_min: Int
    var sprinker_sec: Int
    
    init(id: String, authorName: String, timeStampText: Double, authID: String,
         title: String, description: String, numberOfLikes: Int, numberOfTrials: Int, lights: Int, sprinklers: Int, humidity: Int, temp: Int, light_hour: Int, light_min: Int, sprinkler_days: Int,  sprinkler_hour: Int, sprinkler_min: Int, light_sec: Int = 0, sprinkler_sec: Int = 0) {
        self.id = id
        self.authorName = authorName
        self.timeStamp = timeStampText
        self.createdAt = Date(timeIntervalSince1970: timeStampText / 1000).calendarTimeSinceNow()
        self.authID = authID
        self.title = title
        self.description = description
        self.numberOfLikes = numberOfLikes
        self.numberOfTrials = numberOfTrials
        
        self.lights = lights
        self.sprinklers = sprinklers
        self.humidity = humidity
        self.temp = temp
        
        self.light_hour = light_hour
        self.light_min = light_min
        self.light_seconds = light_sec
        
        self.sprinkler_days = sprinkler_days
        self.sprinkler_hour = sprinkler_hour
        self.sprinkler_min = sprinkler_min
        self.sprinker_sec = sprinkler_sec
    }
    
    // removes  likes and updates the database to reflect the change
    func removeLike() {
        self.numberOfLikes -= 1
        //CommunityPresetFunctions.updatePost(post: self)
        CommunityPresetFunctions.updatePost(post: self)
    }
    // adds  likes and updates the database to reflect the change
    func addLike() {
        self.numberOfLikes += 1
        CommunityPresetFunctions.updatePost(post: self)
    }
    
    // adds trial and updates the database to reflect the change
    func addTrial() {
        self.numberOfTrials += 1
        //CommunityPresetFunctions.updatePost(post: self)
        CommunityPresetFunctions.updatePost(post: self)
    }
    
}


// Backend helper functions for community presets to interract with the db
class CommunityPresetFunctions {
    
    var postsList: [Post] = []
    
    /*
     updates the database post for a given preset
     @param post: Post - a Post object containing the
        information to update the database
     */
    static func updatePost(post: Post) {
        let ref = Database.database().reference()
        let postInfo = [
            "authID": post.authID,
            "author": post.authorName,
            "timeStamp": post.timeStamp,
            "title": post.title,
            "description": post.description,
            "likes": post.numberOfLikes,
            "trials": post.numberOfTrials
        ] as [String:Any]
        
        let postSendback = ["activate_lights": post.lights,
                            "activate_sprinklers": post.sprinklers,
                            "target_humidity": post.humidity,
                            "target_temp": post.temp,
                            "light_time": ["hour": post.light_hour,
                                           "minute": post.light_min,
                                           "second": post.light_seconds],
                            "sprinkler_time": ["day": post.sprinkler_days,
                                               "hour": post.sprinkler_hour,
                                              "minute": post.sprinkler_min,
                                              "second": post.sprinker_sec]
            ] as [String : Any]

        ref.child("Community").child(post.id).child("postInfo").setValue(postInfo)
        ref.child("Community").child(post.id).child("postSendback").setValue(postSendback)
    }
    
    /*
     Creates a new database post for a given preset
     @param post: Post - a Post object containing the
        information to update the database
     */
    static func setNewPost(post: Post) {
        let ref = Database.database().reference()
        let postInfo = [
            "authID": post.authID,
            "author": post.authorName,
            "timeStamp": [".sv": "timestamp"],
            "title": post.title,
            "description": post.description,
            "likes": post.numberOfLikes,
            "trials": post.numberOfTrials
        ] as [String:Any]
        
        let postSendback = ["activate_lights": post.lights,
                            "activate_sprinklers": post.sprinklers,
                            "target_humidity": post.humidity,
                            "target_temp": post.temp,
                            "light_time": ["hour": post.light_hour,
                                           "minute": post.light_min,
                                           "second": post.light_seconds],
                            "sprinkler_time": ["day": post.sprinkler_days,
                                               "hour": post.sprinkler_hour,
                                              "minute": post.sprinkler_min,
                                              "second": post.sprinker_sec]
            ] as [String : Any]

        ref.child("Community").child(post.id).child("postInfo").setValue(postInfo)
        ref.child("Community").child(post.id).child("postSendback").setValue(postSendback)

    }
    
    /*
     sets the database information for the device sendback to reflect the
     values entered in a community preset
     @param devID: String - the device to edit
     @param post: Post - the preset to update the values with
     */
    static func useCommunityPreset(devID: String, post: Post) {
        let ref = Database.database().reference()
        
        let sendback = ["activate_lights": post.lights,
                        "activate_sprinklers": post.sprinklers,
                        "target_humidity": post.humidity,
                        "target_temp": post.temp,
                        "light_time": ["hour": post.light_hour,
                                       "minute": post.light_min,
                                       "second": post.light_seconds],
                        "sprinkler_time": ["day": post.sprinkler_days,
                                           "hour": post.sprinkler_hour,
                                          "minute": post.sprinkler_min,
                                          "second": post.sprinker_sec]
        ] as [String : Any]
        
        ref.child("device").child(devID).child("sendback").setValue(sendback)
    }
    
    /*
     Observes firebase list of posts to keep an updated feed on the community page
     */
    func observePosts() {
        let postRef = Database.database().reference().child("Community")
        let quearyRef = postRef.queryOrdered(byChild: "timeStamp").queryLimited(toLast: 20)
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
                let light_sec = light_time["second"] as? Int
                
                guard let sprinkler_time = val["sprinkler_time"] as? [String: Any] else {return}
                print("made it")
                let sprinkler_days = sprinkler_time["day"] as? Int
                let sprinkler_h = sprinkler_time["hour"] as? Int
                let sprinkler_min = sprinkler_time["minute"] as? Int
                let sprinkler_s = sprinkler_time["day"] as? Int
                
                
                let post = Post(id: id, authorName: author ?? "", timeStampText: timeStamp ?? 0 , authID: authID ?? "", title: title ?? "", description: desc ?? "desc", numberOfLikes: likes ?? 0, numberOfTrials: trials ?? 0, lights: actLights ?? 0, sprinklers: actSprink ?? 0, humidity: targetHum ?? 20, temp: targetTemp ?? 20, light_hour: light_h ?? 0, light_min: light_min ?? 0, sprinkler_days: sprinkler_days ?? 0, sprinkler_hour: sprinkler_h ?? 0, sprinkler_min: sprinkler_min ?? 0)
                
                if post.authorName !=  "" && post.authID != "" && post.title != "" && post.description  != "" {
                    tempPosts.insert(post, at: 0)
                }
                
                print("post added!")
            }
            self.postsList = tempPosts
            print("temp \(tempPosts) post list \(self.postsList)")
            //print(self.postsList)
        })
    }
}
