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
    
    var db : WeatherDatabase? = nil
    var cv_zipCode: [String] = []
    var cv_cityName: [String] = []
    var cv_state: [String] = []
    var cv_temp: [String] = []
    var cv_weatherCondition: [String] = []
    var deleteZipIndexPath: IndexPath? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.toolbar.barTintColor = UIColor.init(red: 26/255, green: 152/255, blue: 252/255, alpha: 1.0)
        updateWeatherTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteZipIndexPath = indexPath
            let zipToDelete = cv_zipCode[indexPath.row]
            confirmDelete(zip: zipToDelete)
        }
    }
    
    func confirmDelete(zip: String) {
        let alert = UIAlertController(title: "Delete Zip Code", message: "Are you sure you want to permanently delete \(zip)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteZip)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteZip)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeleteZip(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteZipIndexPath {
            weatherTableView.beginUpdates()
            
            db?.removeZip(zip: cv_zipCode[indexPath.row])
            
            cv_zipCode.remove(at: indexPath.row)
            cv_temp.remove(at: indexPath.row)
            cv_state.remove(at: indexPath.row)
            cv_cityName.remove(at: indexPath.row)
            cv_weatherCondition.remove(at: indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            weatherTableView.deleteRows(at: [indexPath], with: .automatic)
            
            deleteZipIndexPath = nil
            
            weatherTableView.endUpdates()
        }
    }
    
    func cancelDeleteZip(alertAction: UIAlertAction!) {
        deleteZipIndexPath = nil
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    
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
        cell.vv_lblTemp?.text = self.cv_temp[(indexPath as NSIndexPath).row] + "\u{00B0}F"
        
        return cell
    }
    
    //Table cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueDetailedInfo") {
            if let destination = segue.destination as? DetailedViewController {
                if let lv_index = weatherTableView.indexPathForSelectedRow {
                    destination.cv_weatherCondition = cv_weatherCondition[(lv_index as NSIndexPath).row]
                    destination.cv_city = cv_cityName[(lv_index as NSIndexPath).row]
                    destination.cv_state = cv_state[(lv_index as NSIndexPath).row]
                    destination.cv_temp = cv_temp[(lv_index as NSIndexPath).row]
                }
            }
        }
    }
    
    @IBOutlet var weatherTableView: UITableView!
    @IBAction func resetDatabase(_ sender: UIBarButtonItem) {
        db?.resetDatabase()
        cv_temp.removeAll()
        cv_weatherCondition.removeAll()
        cv_state.removeAll()
        cv_zipCode.removeAll()
        cv_cityName.removeAll()
        updateWeatherTable()
        weatherTableView.reloadData()
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        cv_temp.removeAll()
        cv_weatherCondition.removeAll()
        cv_state.removeAll()
        cv_zipCode.removeAll()
        cv_cityName.removeAll()
        updateWeatherTable()
        weatherTableView.reloadData()
    }
    
    //Updates arrays based on JSON
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
            
            //Get temperature
            if let json = owm_json as? [String: AnyObject] {
                if let main = json["main"] as? [String: AnyObject] {
                    if let temp = main["temp"] as? NSNumber {
                        cv_temp.append(temp.description)
                    }
                }
            }
            
            //Get weather description
            if let json = owm_json as? [String: AnyObject] {
                if let weather = json["weather"] as? NSArray {
                    if let nestedDictionary = weather[0] as? NSDictionary {
                        if let weatherDescription = nestedDictionary["main"] as? String {
                            cv_weatherCondition.append(weatherDescription)
                        }
                    }
                }
            }
        }
    }
}

