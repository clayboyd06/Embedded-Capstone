//
//  SignUpViewController.swift
//  Terrabox
//
//  Created by Clay Boyd on 1/29/22.
//
// Creates sign up page to authenticate user with Firbase



import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class SignUpViewController: UIViewController {
    
    private let ref = Database.database().reference()

    @IBOutlet weak var passLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        Utils.styleTextField(firstNameTextField)
        Utils.styleTextField(lastNameTextField)
        Utils.styleTextField(emailTextField)
        Utils.styleTextField(passTextField)
        Utils.styleFilledButton(signUpButton)
        Utils.styleFilledButton(backButton)
        Utils.styleLabel(firstNameLabel)
        Utils.styleLabel(lastNameLabel)
        Utils.styleLabel(emailLabel)
        Utils.styleLabel(passLabel)
        Utils.styleLabel(signUpTitle)
    }
    

    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        guard let displayName = firstNameTextField.text else {return}
        guard let email = emailTextField.text else {return}
        guard let pass = passTextField.text else {return}
        
        Utils.setContinueButton(enabled: false, button: signUpButton)
        signUpButton.setTitle("", for: .normal)

        Auth.auth().createUser(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                print("user created")
                 
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = displayName
                changeRequest?.commitChanges { error in
                    if error == nil {
                        Auth.auth().signIn(withEmail: email, password: pass)
                        let uid = Auth.auth().currentUser!.uid
                        self.saveUser(uid: uid, user: displayName, email: email, password: pass)
                        self.goHome()
                    }
                }
            }
            else {
                print("error: \(error!.localizedDescription)")
                self.resetForm()
            }
            
        }
    }
    
    func resetForm() {
        let alert = UIAlertController(title: "Error signing up", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default , handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        Utils.setContinueButton(enabled: true, button: signUpButton)
        signUpButton.setTitle("Add Device", for: .normal)
    }

    func saveUser(uid: String, user: String, email: String, password: String) {
        let post : [String: Any] = ["user": user, "email" : email, "password": password, "devices": ["device":""]]

        self.ref.child("users").child(uid).setValue(post)
    }
    
    func goHome() {
        let controller = storyboard?.instantiateViewController(withIdentifier: Constants.StoryBoard.homeViewController) as? HomeViewController
        view.window?.rootViewController = controller
        view.window?.makeKeyAndVisible()
    }
    
    
}
