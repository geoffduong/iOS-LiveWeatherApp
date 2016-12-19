//
//  DetailedViewController.swift
//  LiveWeatherApp
//
//  Created by Geoffrey Duong on 12/18/16.
//  Copyright © 2016 Geoffrey Duong. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    
    var cv_weatherCondition : String?
    var cv_city: String?
    var cv_state: String?
    var cv_temp: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_weatherPicture.font = UIFont(name: "WeatherIcons", size: 100)
        switch (cv_weatherCondition!) {
        case "Clear":
            lbl_weatherPicture.text = "J"
            break
        case "Haze":
            lbl_weatherPicture.text = "C"
            break
        case "Snow":
            lbl_weatherPicture.text = "H"
            break
        case "Clouds":
            lbl_weatherPicture.text = "A"
            break
        case "Rain", "Drizzle":
            lbl_weatherPicture.text = "G"
            break
        case "Thunderstorm":
            lbl_weatherPicture.text = "I"
            break
        default:
            lbl_weatherPicture.text = "L"
            break
        }
        
        lbl_weatherCondition.text = cv_weatherCondition
        lbl_temperature.text = cv_temp! + "\u{00B0}F"
        lbl_city.text = cv_city
        lbl_state.text = cv_state
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var lbl_weatherPicture: UILabel!
    @IBOutlet weak var lbl_weatherCondition: UILabel!
    @IBOutlet weak var lbl_temperature: UILabel!
    @IBOutlet weak var lbl_city: UILabel!
    @IBOutlet weak var lbl_state: UILabel!
}
