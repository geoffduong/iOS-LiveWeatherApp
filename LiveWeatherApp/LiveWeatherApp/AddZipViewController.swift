//
//  AddZipViewController.swift
//  LiveWeatherApp
//
//  Created by Geoffrey Duong on 12/2/16.
//  Copyright © 2016 Geoffrey Duong. All rights reserved.
//

import UIKit

class AddZipViewController: UIViewController {
    
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
        
        let lv_url = URL(string: "http://ziptasticapi.com/" + sender.text!)!
        let lv_data : Data = try! Data(contentsOf: lv_url)
        
        let lv_json = try! JSONSerialization.jsonObject(with: lv_data, options:.allowFragments) as! [String:AnyObject]
        
        //Error/Invalid Zip
        if (lv_json["error"] as? String) != nil {
            vv_lblResult.text = "No such zip code"
        }
            
        //Valid Zip
        else {
            let lv_state = lv_json["state"] as! String
            let lv_city = lv_json["city"] as! String
            
            let cv_str = "Address ->  \(lv_city), \(lv_state)"
            vv_lblResult.text = cv_str
            //prepare(for: "segueValidZip", sender: sender)
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     */
    
    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "segueValidZip") {
            if let destination = segue.destination as? ViewController {
                destination.cv_zipCode.append("48176")
                destination.cv_temp.append("23")
                destination.cv_state.append("MI")
                destination.cv_cityName.append("Saline")
            }
        }
    }
    
}
