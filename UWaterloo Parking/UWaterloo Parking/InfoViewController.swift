//
//  ViewController.swift
//  servicestab
//
//  Created by Phoenix on 2016-02-13.
//  Copyright © 2016 Phoenix. All rights reserved.
//

import UIKit
import MapKit

class InfoViewController: UIViewController {
    
    @IBOutlet var desc: UILabel!
    
    @IBOutlet var locationinput: UILabel!
    
    @IBOutlet var hoursinput: UILabel!
    
    @IBOutlet var phoneinput: UILabel!
    
    @IBOutlet var emailinput: UILabel!
    
    @IBOutlet var homepageinput: UIButton!
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
         self.navigationItem.title = "INFO"
        
        
        RestApiManager.sharedInstance.getData { json in
            let results = json["data"]
            
            for (index: _, subJson: Json) in results {
                if Json["name"] == "Parking Services" {
                    
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.desc.text =  Json["description"].string
                        self.hoursinput.text =  Json["opening_hours"].string
                        self.locationinput.text =  Json["note"].string! + "  154"
                        self.desc.text =  Json["description"].string
                        self.phoneinput.text =  Json["phone"].string
                        self.emailinput.text =  Json["email"].string
                        self.homepageinput.setTitle(Json["url"].string, forState: .Normal)
                        self.latitude = Json["latitude"].double!
                        self.longitude = Json["longitude"].double!
                    })
                }
            }
        }    
    }
    
    @IBAction func homepageDir(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: self.homepageinput.currentTitle! )!)
        print("done")
    }
    
    @IBAction func Direaction(sender: AnyObject) {
        print("done")
        
        let currentLocation = MKMapItem.mapItemForCurrentLocation()
        //let markDC = MKPlacemark(coordinate: CLLocationCoordinate2DMake(43.47155, -80.54565), addressDictionary: nil)
        
        let markDestLocation = MKPlacemark(coordinate: CLLocationCoordinate2DMake(self.latitude, self.longitude), addressDictionary: nil)
        let destLocation = MKMapItem(placemark: markDestLocation)
        
        destLocation.name = "Parking Services"
        //destLocation.openInMapsWithLaunchOptions(nil)
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        //MKMapItem.openMapsWithItems([currentLocation, destLocation], launchOptions: launchOptions)
        MKMapItem.openMapsWithItems([currentLocation, destLocation], launchOptions: launchOptions)
     
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
        
        
    }
    
    
}

