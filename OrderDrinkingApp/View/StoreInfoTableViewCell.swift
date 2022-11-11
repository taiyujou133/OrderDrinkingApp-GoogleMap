//
//  StoreInfoTableViewCell.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/10.
//

import UIKit
import GoogleMaps

class StoreInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
