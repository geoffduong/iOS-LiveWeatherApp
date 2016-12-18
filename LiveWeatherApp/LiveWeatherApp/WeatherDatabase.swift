//
//  WeatherDatabase.swift
//  LiveWeatherApp
//
//  Created by Geoffrey Duong on 12/11/16.
//  Copyright © 2016 Geoffrey Duong. All rights reserved.
//

import Foundation
import SQLite

class WeatherDatabase {
    var db : Connection?
    var zipCodeArray: [String] = ["85365", "99703", "48197"]
    
    //Vars to access database
    let zipCode = Expression<String?>("zipCode")
    let users = Table("zipCodes")
    
    init() {
        do {
            //Open connection to database
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            db = try Connection("\(path)/zipCode.sqlite3")
            
            
            
            //If table doesn't exist, create it
            try db?.run(users.create(ifNotExists: true) { t in
                t.column(zipCode, unique: true)
            })
            
            //TEST: Adding to database
            try db?.run(users.insert(zipCode <- "85365"))
            try db?.run(users.insert(zipCode <- "99703"))
            try db?.run(users.insert(zipCode <- "48197"))
        }
        catch {
            print(error)
        }
    }
    
    //Get array of zipcodes
    func getArray() -> Array<String> {
        return zipCodeArray
    }
    
    //Add zipCode to database
    func addZip(inputZip: String) {
        do {
            try db?.run(users.insert(zipCode <- inputZip))
//            if (!zipCodeArray.contains(inputZip)) {
//                zipCodeArray.append(inputZip)
//            }
        }
        catch {
            print(error)
        }
    }
    
    //    func getArray() -> Array<Any> {
    //        if let test = Array(try db?.prepare(users)) {
    //            let lol = test
    //            return lol
    //        }
    //        catch {
    //            print(error)
    //        }
    //    }
    
}
