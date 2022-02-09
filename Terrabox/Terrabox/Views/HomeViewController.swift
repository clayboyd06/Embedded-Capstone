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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView:UITableView!
    private let ref = Database.database().reference()
    
    @IBOutlet weak var myDevices: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var addDevice: UIButton!
    
    var deviceListData = [
        "demo1234", "123343435fv", "766ey"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDeviceList() // delay ???
        
        // Format the table view
        tableView = UITableView(frame: CGRect(
            x: 20,
            y: view.frame.size.height / 2 + 150,
            width: (view.frame.size.width - 40),
            height: view.frame.size.height / 2 - 300 ), style: .plain)
        view.addSubview(tableView)
        
        // "User's Devices" Formatting
        myDevices.frame = CGRect(
            x: 20,
            y: view.frame.size.height / 2 + 90 ,
            width: (view.frame.size.width - 40),
            height: 40)
        setName()
        
        // Link the tableview class to the data
        let cellNib = UINib(nibName: "DeviceTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "deviceCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
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
        ref.child("users").child(uid).child("devices").observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String: String] else {
                    self.deviceListData.append("there was error")
                    return}
               
                let deviceID = dict["Device ID"]!
                self.deviceListData.append(deviceID)
            }
        }
    }
    
    // Goes to the controller page for each of the buttons in
    // the table view
    @objc func deviceButtonTapped(sender: UIButton) {
        // store title as ID
        
        // go to controller page
        let controller = storyboard?.instantiateViewController(withIdentifier: "envControl") as? HomeViewController
        view.window?.rootViewController = controller
        view.window?.makeKeyAndVisible()
    }
    
    
    
    
    
    
    // built in table view functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceListData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell", for: indexPath) as! DeviceTableViewCell
        cell.set(deviceID: deviceListData[indexPath.row])
        return cell
    }
    
} // end class



