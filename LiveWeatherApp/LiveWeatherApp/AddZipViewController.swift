//
//  AddZipViewController.swift
//  LiveWeatherApp
//
//  Created by Geoffrey Duong on 12/2/16.
//  Copyright © 2016 Geoffrey Duong. All rights reserved.
//

import UIKit
import Foundation
import SQLite

class AddZipViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //OUTLETS----------------------------------------
    @IBOutlet weak var vv_textFieldZip: UITextField!
    @IBOutlet weak var lbl_error: UILabel!
    //-----------------------------------------------
    
    //Button click
    @IBAction func btnClick(_ sender: Any) {
        if vv_textFieldZip.text != "" {
            //Checking for valid zip
            let zip_url = URL(string: "http://ziptasticapi.com/" + vv_textFieldZip.text!)!
            let zip_data : Data = try! Data(contentsOf: zip_url)
            let zip_json = try! JSONSerialization.jsonObject(with: zip_data, options:.allowFragments) as! [String:AnyObject]
            
            //Error/Invalid Zip
            if (zip_json["error"] as? String) != nil {
            }
                
                //Valid Zip
            else {
                let db: WeatherDatabase = WeatherDatabase()
                db.addZip(inputZip: vv_textFieldZip.text!)
                self.performSegue(withIdentifier: "unwindToViewController", sender: self)
            }
        }
        else {
            lbl_error.text = "Please enter a valid zip code"
        }
    }
    
    @IBAction func textFieldReturn(_ sender: UITextField) {
        if sender.text != "" {
            //Checking for valid zip
            let zip_url = URL(string: "http://ziptasticapi.com/" + sender.text!)!
            let zip_data : Data = try! Data(contentsOf: zip_url)
            let zip_json = try! JSONSerialization.jsonObject(with: zip_data, options:.allowFragments) as! [String:AnyObject]
            
            //Error/Invalid Zip
            if (zip_json["error"] as? String) != nil {
            }
                
                //Valid Zip
            else {
                let db: WeatherDatabase = WeatherDatabase()
                db.addZip(inputZip: sender.text!)
                self.performSegue(withIdentifier: "unwindToViewController", sender: self)
            }
        }
        else {
            lbl_error.text = "Please enter a valid zip code"
        }
    }
    
}
