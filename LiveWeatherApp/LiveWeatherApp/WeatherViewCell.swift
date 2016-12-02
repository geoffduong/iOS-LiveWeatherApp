//
//  WeatherViewCell.swift
//  LiveWeatherApp
//
//  Created by Geoffrey Duong on 12/2/16.
//  Copyright © 2016 Geoffrey Duong. All rights reserved.
//

import UIKit

class WeatherViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //OUTLETS-------------------------------------
    
    @IBOutlet weak var vv_lblCityName: UILabel!
    @IBOutlet weak var vv_lblZipCode: UILabel!
    @IBOutlet weak var vv_lblState: UILabel!
    @IBOutlet weak var vv_lblTemp: UILabel!

    //--------------------------------------------
    
    
    
}
