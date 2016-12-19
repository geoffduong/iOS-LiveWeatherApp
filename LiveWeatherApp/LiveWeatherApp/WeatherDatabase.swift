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
            
            let count = try db?.scalar(users.count)
            if count == 0 {
                try db?.run(users.insert(zipCode <- "85365"))
                try db?.run(users.insert(zipCode <- "99703"))
                try db?.run(users.insert(zipCode <- "48197"))
            }
        }
        catch {
            print(error)
        }
    }
    
    
    //Add zipCode to database
    func addZip(inputZip: String) {
        do {
            try db?.run(users.insert(zipCode <- inputZip))
        }
        catch {
            print(error)
        }
    }
    
    //Return array with zip codes
    func queryZipCodes() -> [String] {
        do {
            let query = try db?.prepare("SELECT zipCode FROM zipCodes")
            var zipCodes: [String] = []
            for zipCode in query! {
                zipCodes += [zipCode[0] as! String]
            }
            return zipCodes
            
        }
        catch {
            print(error)
        }
        return []
    }
    
    //Reset database
    func resetDatabase() {
        do {
            try db?.run(users.delete())
        }
        catch {
            print(error)
        }
    }
    
    //Remove zip code
    func removeZip(zip: String) {
        do {
            let index = users.filter(zipCode == zip)
            try db?.run(index.delete())
        }
        catch {
            print(error)
        }
    }
}
