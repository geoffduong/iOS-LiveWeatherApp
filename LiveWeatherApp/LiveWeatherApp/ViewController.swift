//
//  ViewController.swift
//  LiveWeatherApp
//
//  Created by Geoffrey Duong on 11/29/16.
//  Copyright © 2016 Geoffrey Duong. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var cv_zipCode: [String] = ["48197", "85365", "99703"]
    
    
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
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "weatherInfoCell")! as UITableViewCell
        
        cell.textLabel?.text = self.cv_zipCode[(indexPath as NSIndexPath).row]
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

