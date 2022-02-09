//
//  LoginViewController.swift
//  Terrabox
//
//  Created by Clay Boyd on 1/29/22.
//
/*
 TODO:
    Create different error messages
        Could not find user
        Password does not match for user
    Add forgot password option and retrieval option
     - Stay signed in option -
 */

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passLabel: UILabel!
    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        Utils.styleTextField(emailTextField)
        Utils.styleTextField(passTextField)
        Utils.styleFilledButton(loginButton)
        Utils.styleFilledButton(backButton)
        Utils.styleLabel(emailLabel)
        Utils.styleLabel(passLabel)
        Utils.styleLabel(loginTitle)
    }
    
    func showError(_ errorMsg: String) {
        errorLabel.text = errorMsg
        errorLabel.alpha = 1
    }

    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text else {return}
        guard let pass = passTextField.text else {return}
        
        Utils.setContinueButton(enabled: false, button: loginButton)
        loginButton.setTitle("", for: .normal)
        
        Auth.auth().signIn(withEmail: email, password: pass) {user, error in
            if error == nil && user != nil {
                self.goHome()
            } else {
                print("Error: \(error!.localizedDescription)")
                self.resetForm()
            }
        }
    }
    
    func resetForm() {
        let alert = UIAlertController(title: "Error Logging In", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default , handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        Utils.setContinueButton(enabled: true, button: loginButton)
        loginButton.setTitle("Login", for: .normal)
    }
    
    func goHome() {
        let controller = storyboard?.instantiateViewController(withIdentifier: Constants.StoryBoard.homeViewController) as? HomeViewController
        view.window?.rootViewController = controller
        view.window?.makeKeyAndVisible()
    }
}
