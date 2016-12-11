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
    
    init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            db = try Connection("\(path)/zipCode.sqlite3")
        }
        catch {
            print(error)
        }
    }
}
