//
//  APIManager.swift
//  servicestab
//
//  Created by Phoenix on 2016-02-13.
//  Copyright © 2016 Phoenix. All rights reserved.
//

import Foundation


//typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    
    var baseURL = "https://api.uwaterloo.ca/v2/poi/visitorinformation.json"
    
    let APIkey = "2fa6eb226bdc853b6dd71e6f7bd5a822"
    // https://api.uwaterloo.ca/v2/poi/visitorinformation.json?key=2fa6eb226bdc853b6dd71e6f7bd5a822
    
    var basebuildingURL = "https://api.uwaterloo.ca/v2/buildings/list.json"
    var baseParkingURL = "https://api.uwaterloo.ca/v2/parking/watpark.json"
    
    //https://api.uwaterloo.ca/v2/buildings/list.json?key=2fa6eb226bdc853b6dd71e6f7bd5a822
    
    
    var parkingReqURL = "https://api.uwaterloo.ca/v2/parking/watpark.json?key=1f3c24ff0e62c935e11722c4989b2043"
    
    
    func getBuildingData(onCompletion: (JSON) -> Void) {
        makeHTTPGetRequest(basebuildingURL+"?key="+APIkey, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    func getParkingData(onCompletion: (JSON) -> Void) {
        makeHTTPGetRequest(baseParkingURL+"?key="+APIkey, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    func getData(onCompletion: (JSON) -> Void) {
        makeHTTPGetRequest(baseURL+"?key="+APIkey, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    
    
    
    //helen
    func getParkingLotLocation(lot: String, onCompletion: (latitude: Double, longitude: Double) -> Void) {
        let route = parkingReqURL
        makeHTTPGetRequest(route) { (obj, err) in
            var latitude: Double = 0.00
            var longitude: Double = 0.00
            let lotList = obj["data"]
            for (index: String, subJson) in lotList {
                let lotName = subJson["lot_name"].string
                if lotName == lot {
                    latitude = subJson["latitude"].double!
                    longitude = subJson["longitude"].double!
                    break
                }
            }
            onCompletion(latitude: latitude, longitude: longitude)
        }
        
    }
    
    func getCurrentCountAndCapacity(lot: String, onCompletion: (count: Int, capacity: Int) -> Void) {
        let route = parkingReqURL
        //var count = -1
        makeHTTPGetRequest(route) { (obj, err) in
            var count: Int = -1
            var capacity: Int = -1
            let data = obj["data"]
            for (index: String, subJson) in data {
                let lotName = subJson["lot_name"].string
                if lotName == lot {
                    count = subJson["current_count"].int!
                    capacity = subJson["capacity"].int!
                    break
                }
            }
            onCompletion(count: count, capacity: capacity)
        }
    }
    //helen
    
    
    
    
    func makeHTTPGetRequest(path: String, onCompletion: (JSON, NSError?) -> Void) {
        
        let urlRequest = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest, completionHandler: {data, response, err -> Void in
            let json:JSON = JSON(data: data!)
            onCompletion(json, err)
        })
        task.resume()
    }
}