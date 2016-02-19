//
//  ViewController.swift
//  searchtab1
//
//  Created by Phoenix on 2016-02-17.
//  Copyright © 2016 Phoenix. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {
    
    @IBOutlet var Input: UITextField!
    @IBOutlet var LotInfo: UITextField!
    @IBOutlet var TravelTimeInfo: UITextField!
    
    var result:JSON = []
    
    struct Lot {
        var name: String
        var latitude: Double
        var longitude: Double
        
    }
    
    
    var lotlist = [Lot]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        RestApiManager.sharedInstance.getBuildingData { json in
            self.result = json["data"]
            //print(self.result)
        }
        
        RestApiManager.sharedInstance.getParkingData { json in
            let lotResult = json["data"]
            //print(lotResult)
            
            for (index: _, subJson: Json) in lotResult {
                
                self.lotlist.append(Lot(name:Json["lot_name"].string!, latitude:Json["latitude"].doubleValue, longitude:Json["longitude"].doubleValue))
                //print(Json["lot_name"].string!)
                
            }
            //print(self.lotlist)
            
            
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SearchAction(sender: AnyObject) {
        
        self.LotInfo.text = ""
        self.TravelTimeInfo.text = ""
        
        let tmpinput = self.Input.text
        //var request = MKDirectionsRequest()
        //var userLocation = MKPlacemark()
        //var userLocation = MKMapItem.init()
        //var markDestLot = MKPlacemark()
        var tmpLatitude = 0.0
        var tmpLongitude = 0.0
        var tmpTime: Double = 0.0
        var tmpLot:String = ""
        
        
        if (tmpinput == "") {
            self.LotInfo.text = "Please enter a locatoon"
        } else {
            
            for (index: _, subJson: Json) in self.result {
                
                if Json["building_code"].string == tmpinput {
                    
                    print(Json["latitude"].doubleValue)
                    print(Json["longitude"].doubleValue)
                    
                    if (Json["latitude"].doubleValue == 0.0 || Json["longitude"].doubleValue == 0.0) {
                        self.LotInfo.text = "no source available for \(tmpinput!)"
                        return
                    }
                    
                    
                    for index in 0..<self.lotlist.count {
                        print(self.lotlist[index].name)
                        print(self.lotlist[index].latitude)
                        print(self.lotlist[index].longitude)
                        
                        //userLocation = MKMapItem.mapItemForCurrentLocation()
                        let markDC = MKPlacemark(coordinate: CLLocationCoordinate2DMake(Json["latitude"].doubleValue , Json["longitude"].doubleValue), addressDictionary: nil)
                        var markDestLot = MKPlacemark(coordinate: CLLocationCoordinate2DMake(self.lotlist[index].latitude, self.lotlist[index].longitude), addressDictionary: nil)
                        
                        var request = MKDirectionsRequest()
                        request.source = MKMapItem(placemark: markDC)
                        //request.source = MKMapItem.mapItemForCurrentLocation()
                        request.destination = MKMapItem(placemark: markDestLot)
                        request.transportType = .Walking
                        
                        let direction = MKDirections(request: request)
                        direction.calculateETAWithCompletionHandler { response, error -> Void in
                            if let err = error {
                                self.LotInfo.text = err.userInfo["NSLocalizedFailureReason"] as? String
                                print("what!!!!")
                                return
                            }
                            print("what ---- 1")
                            print(response!.expectedTravelTime/60)
                            print(tmpTime)
                            if index == 0 {
                                tmpTime = response!.expectedTravelTime/60
                                tmpLot = self.lotlist[index].name
                            } else if response!.expectedTravelTime/60 < tmpTime {
                                tmpTime = response!.expectedTravelTime/60
                                tmpLot = self.lotlist[index].name
                            }
                            print(tmpTime)
                        }
                        
                    }
                    
                    
                    print("inside for loop")
                    
                    //dispatch_async(dispatch_get_main_queue(), {
                    
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                        self.LotInfo.text = "closest parking lot \(tmpLot) "
                        self.TravelTimeInfo.text = "\(tmpTime) minutes travel time"
                    }
                    
                    
                    
                    //})
                    
                    break
                    
                    
                }
                
                
            }
            self.LotInfo.text = "Does not exist building \(tmpinput!)"
            
        }
        
    }
    
}

