//
//  ViewController.swift
//  LiveWeatherApp
//
//  Created by Geoffrey Duong on 11/29/16.
//  Copyright © 2016 Geoffrey Duong. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UITableViewController {
    
    //DATABASE--------------------------------------------------
    var db : WeatherDatabase? = nil
    //----------------------------------------------------------
    
    //TEST ARRAYS-----------------------------------------------
//    var cv_zipCode: [String] = ["48197", "85365", "99703"]
//    var cv_cityName: [String] = ["Ypsilanti", "Yuma", "Fort Wainwright"]
//    var cv_state: [String] = ["MI", "AZ", "AK"]
//    var cv_temp: [String] = ["55", "75", "34"]
//    var cv_weatherCondition: [String] = ["Snow", "Rain", "Clear"]
    var cv_zipCode: [String] = []
    var cv_cityName: [String] = []
    var cv_state: [String] = []
    var cv_temp: [String] = []
    var cv_weatherCondition: [String] = []
    //----------------------------------------------------------
    
    
    
    //Onload----------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello")
        let owm_url = URL(string: "http://api.openweathermap.org/data/2.5/weather?zip=48176,us&appid=d5bf1afd8b284f2ac9ea60d9d5a2557e&units=imperial")!
        let owm_data : Data = try! Data(contentsOf: owm_url)
        let owm_json = try! JSONSerialization.jsonObject(with: owm_data, options: .allowFragments) as! [String:AnyObject]
        print(owm_json)
        updateWeatherTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //----------------------------------------------------------
    
    
    //TableView functions---------------------------------------
    //Get number of rows for TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cv_zipCode.count
    }
    
    //Info to be displayed for each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:WeatherViewCell = self.tableView.dequeueReusableCell(withIdentifier: "weatherInfoCell")! as! WeatherViewCell
        
        cell.vv_lblCityName?.text = self.cv_cityName[(indexPath as NSIndexPath).row]
        cell.vv_lblZipCode?.text = self.cv_zipCode[(indexPath as NSIndexPath).row]
        cell.vv_lblState?.text = self.cv_state[(indexPath as NSIndexPath).row]
        cell.vv_lblTemp?.text = self.cv_temp[(indexPath as NSIndexPath).row] + "\u{00B0}"
        
        return cell
    }
    
    //Table cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    //When cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowValue = cv_zipCode[(indexPath as NSIndexPath).row]
        let message = "You selected \(rowValue)"
        let controller = UIAlertController(title: "Row Selected", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes I Did", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    //------------------------------------------------------------
    @IBOutlet var weatherTableView: UITableView!
    
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        //updateWeatherTable()
        weatherTableView.reloadData()
    }
    
    func updateWeatherTable() {
        db = WeatherDatabase()
        let test = db?.queryZipCodes()
        for zip in test! {
            
            //Append to zip code array
            cv_zipCode.append(zip)
            
            //Append to states and cities array
            let zip_url = URL(string: "http://ziptasticapi.com/\(zip)")!
            let zip_data : Data = try! Data(contentsOf: zip_url)
            let zip_json = try! JSONSerialization.jsonObject(with: zip_data, options:.allowFragments) as! [String:AnyObject]
            let zip_state = zip_json["state"] as! String
            let zip_city = zip_json["city"] as! String
            cv_state.append(zip_state)
            cv_cityName.append(zip_city)
            
            //Append to temperature and weather condition array
            let owm_url = URL(string: "http://api.openweathermap.org/data/2.5/weather?zip=\(zip),us&appid=d5bf1afd8b284f2ac9ea60d9d5a2557e&units=imperial")!
            let owm_data : Data = try! Data(contentsOf: owm_url)
            let owm_json = try! JSONSerialization.jsonObject(with: owm_data, options: .allowFragments) as! [String: AnyObject]
            
            if let json = owm_json as? [String: AnyObject] {
                if let main = json["main"] as? [String: AnyObject] {
                    if let temp = main["temp"] as? NSNumber {
                        cv_temp.append(temp.description)
                    }
                }
            }
        
//            let owm_json = try! JSONSerialization.jsonObject(with: owm_data, options: .allowFragments) as! [String:AnyObject]
//            cv_temp.append("47")
//            cv_weatherCondition.append("Clear")
            
//            if let nestedDictionary = owm_json["main"] as! [String: Any] {
//                cv_temp.append(nestedDictionary.)
//            }
//
//            if let array = owm_json["weather"] as? [String: Any] {
//                if let weather = array.first {
//                    cv_weatherCondition.append(weather.value as! String)
//                }
//            }
        }
    }
}

