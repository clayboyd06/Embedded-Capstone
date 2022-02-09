//
//  DeviceTableViewCell.swift
//  Terrabox
//
//  Created by Clay Boyd on 2/7/22.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(deviceID: String) {
        button.setTitle(deviceID, for: .normal)
    }
}
