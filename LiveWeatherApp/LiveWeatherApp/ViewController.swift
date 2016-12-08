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
    //let db = try Connection(":zipCode.db") throws -> String

    //TEST ARRAYS-----------------------------------------------
    var cv_zipCode: [String] = ["48197", "85365", "99703"]
    var cv_cityName: [String] = ["Ypsilanti", "Yuma", "Fort Wainwright"]
    var cv_state: [String] = ["MI", "AZ", "AK"]
    var cv_temp: [String] = ["55", "75", "34"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


}

