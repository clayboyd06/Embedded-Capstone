//
//  HomeViewController.swift
//  Terrabox
//
//  Created by Clay Boyd on 1/30/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {

    private let ref = Database.database().reference()
    
    @IBOutlet weak var myDevices: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var addDevice: UIButton!
    @IBOutlet weak var chooseDev: UIButton!
    @IBOutlet weak var deviceList: UIPickerView!
  
    var deviceListData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Style elements
        Utils.styleFilledButton(chooseDev)
        setName()
        
        //getDeviceList()
        self.deviceList.delegate = self
        self.deviceList.dataSource = self
        
        deviceListData = deviceArr
    }
    
    
    func setUpElements() {
        view.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
    }
    
    
    // signs out the user and sends the user back to the sign in page 
    @IBAction func signOutButtonTapped(_ sender: Any) {
        try! Auth.auth().signOut()
        let controller = storyboard?.instantiateViewController(withIdentifier: Constants.StoryBoard.startViewController) as? ViewController
        view.window?.rootViewController = controller
        view.window?.makeKeyAndVisible()
    }
    
    // TODO add his view controller and rememeber the device ID to write to
    @IBAction func chooseDeviceTapped(_ sender: Any) {
        //go to Oscar's HomeScreen
    }
    
    // Sets the label for the device list to the current user's name's devices
    func setName() {
        guard let name = Auth.auth().currentUser?.displayName else {return}
        myDevices!.text = "\(name)'s devices"
    }
    
    // Reads the DB for the list of devices under each user
    // and appends to an array that will create the picker view
    // TODO create list instead of children for each device
    // then this will be fixed 
    func getDeviceList() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        ref.child("users").child(uid).child("devices").observeSingleEvent(of: .value, with: { DataSnapshot in
            var deviceArr: [String] =  [String]()
            
        })
    }
    
} // end class

extension HomeViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return deviceListData[row]
    }
}
extension HomeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return deviceListData.count
    }
    
    
}

