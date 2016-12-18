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
    
    var zipToSend: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //OUTLETS----------------------------------------
    @IBOutlet weak var vv_lblResult: UILabel!
    //-----------------------------------------------
    
    
    
    
    @IBAction func verifyZipAndSend(_ sender: UITextField) {
        //Checking for valid zip
        let zip_url = URL(string: "http://ziptasticapi.com/" + sender.text!)!
        let zip_data : Data = try! Data(contentsOf: zip_url)
        let zip_json = try! JSONSerialization.jsonObject(with: zip_data, options:.allowFragments) as! [String:AnyObject]
        
        //Error/Invalid Zip
        if (zip_json["error"] as? String) != nil {
            vv_lblResult.text = "No such zip code"
        }
            
            //Valid Zip
        else {
            let zip_state = zip_json["state"] as! String
            let zip_city = zip_json["city"] as! String
            
            let zip_str = "Address ->  \(zip_city), \(zip_state)"
            vv_lblResult.text = zip_str
            zipToSend = sender.text
            //            sendJSONInfo(validZip: true, sender)
            //prepare(for: "segueValidZip", sender: sender)
        }
    }
    
    func sendJSONInfo(validZip: Bool, _ sender: UITextField) {
        if validZip {
            //If zip is valid, send JSON info to ViewController
            let owm_url = URL(string: "http://api.openweathermap.org/data/2.5/weather?zip=" + sender.text! + ",us&appid=d5bf1afd8b284f2ac9ea60d9d5a2557e&units=imperial")!
            let owm_data : Data = try! Data(contentsOf: owm_url)
            let owm_json = try! JSONSerialization.jsonObject(with: owm_data, options: .allowFragments) as! [String:AnyObject]
            
            if let nestedDictionary = owm_json["main"] as? [String: Any] {
                print(nestedDictionary["temp"])
            }
            
            
            //            let owm_city = owm_json["main"]?["temp"] as! String
            //            let owm_str = "Address ->  \(owm_city)"
            //            print(owm_str)
            //prepare(for: "segueValidZip", sender: sender)
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     */
    
    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if zipToSend != nil {
            let db: WeatherDatabase = WeatherDatabase()
            db.addZip(inputZip: zipToSend!)
            return true
        }
        return false
        
    }
    
    
}
