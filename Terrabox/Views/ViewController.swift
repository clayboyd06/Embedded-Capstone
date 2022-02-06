//
//  ViewController.swift
//  Terrabox
//
//  Created by Clay Boyd on 1/22/22.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController {
    

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if Auth.auth().currentUser != nil {
            //self.performSegue(withIdentifier: "toHomeScreen", sender: self)
            let controller = storyboard?.instantiateViewController(withIdentifier: Constants.StoryBoard.homeViewController) as? HomeViewController
            view.window?.rootViewController = controller
            view.window?.makeKeyAndVisible()
        }
        
    }
    
    func setUpElements() {
        //view.backgroundColor = UIColor.white
        Utils.styleFilledButton(signUpButton)
        Utils.styleFilledButton(loginButton)
    }

}

