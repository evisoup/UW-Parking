//
//  LotsDetailController.swift
//  UWaterloo Parking
//
//  Created by 刘恒邑 on 16/2/17.
//  Copyright © 2016年 Hengyi Liu. All rights reserved.
//

import UIKit
import MapKit

class LotsDetailController: UIViewController {
    
    
    
    @IBOutlet var lotCap: UILabel!
    @IBOutlet var lotPct: UILabel!
    @IBOutlet var lotTime: UILabel!
    @IBOutlet var lotName: UILabel!
    
  
    
    var progress: KDCircularProgress!
    var latitude: Double! = 43.467536
    var longitude: Double! = -80.538379
    var lotPctDouble: Double!
    var lotID = String()
    
    
    func update() {
        
        let url = NSURL(string: "https://api.uwaterloo.ca/v2/parking/watpark.json?key=95e206951aff0f6b6093b0a340c3185f")!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
            if let urlContent = data {
                
                do {
                    
                    let object = try NSJSONSerialization.JSONObjectWithData(urlContent, options: .AllowFragments)
                    
                    if let dictionary = object as? [String: AnyObject]{
                        guard let datas = dictionary["data"] as? [[String: AnyObject]] else {return}
                        
                        
                        for data in datas {
                            guard let name  = data["lot_name"] as? String,
                                let count = data["current_count"] as? Int,
                                let pct = data["percent_filled"] as? Int,
                                //let t = data["last_updated"] as? String,
                                let lat = data["latitude"] as? Double,
                                let lon = data["longitude"] as? Double,
                                
                                let cap = data["capacity"] as? Int else{break}
                            
                            dispatch_async(dispatch_get_main_queue()){
                                switch name{
                                case self.lotID :
                                    self.lotCap.text = "\(count) / \(cap)"
                                    self.lotPct.text = "\(pct)%"
                                    self.lotPctDouble = Double(pct)
                                    
                                    let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
                                    self.lotTime.text = "\(timestamp)"
                                    
                                    self.latitude = lat
                                    self.longitude = lon
                                    self.circularRender()
                                    
                                default:
                                    break
                                }
                            }
                        }
                    }
                    
                    
                } catch {
                    print("JSON serialization failed")
                }
                
            }
            
        }
        
        task.resume()
        
    }
    
    
    func circularRender() {
        let angle = 360 * ( self.lotPctDouble * 0.01 )
        progress.animateFromAngle(0, toAngle: Int(angle), duration: 1)
            { completed in
                if completed {
                    //print("animation stopped, completed")
                } else {
                    print("animation stopped, was interrupted")
                }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterForground", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        progress.startAngle = -90
        progress.progressThickness = 0.25
        progress.trackThickness = 0.25
        progress.trackColor = UIColor(red: 246/255.0, green: 244/255.0, blue: 209/255.0, alpha: 1.0)
        progress.clockwise = true
        progress.gradientRotateSpeed = 1
        progress.roundedCorners = false
        progress.glowMode = .Forward
        progress.glowAmount = 0
        //progress.setColors(UIColor(red: 252/255.0, green: 212/255.0, blue: 80/255.0, alpha: 1.0),UIColor.orangeColor(),UIColor.yellowColor())
        progress.setColors(UIColor(red: 252/255.0, green: 212/255.0, blue: 80/255.0, alpha: 1.0))
//        progress.center = CGPoint(x: view.center.x, y: view.center.y - 80)
        
        progress.center = CGPoint(x: view.center.x, y: view.center.y - 25)
        
        lotName.text = "Lot " + lotID //set up by segue, thus not in update
        lotName.layer.masksToBounds = true;
        lotName.layer.cornerRadius = 8.0;
        view.addSubview(progress)
        update()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func willEnterForground() {
        update()
    }
    
    @IBAction func Direction(sender: AnyObject) {
        
        let currentLocation = MKMapItem.mapItemForCurrentLocation()
        
        let markDestLocation = MKPlacemark(coordinate: CLLocationCoordinate2DMake(self.latitude, self.longitude), addressDictionary: nil)
        let destLocation = MKMapItem(placemark: markDestLocation)
        
        destLocation.name = "Parking Lot \(lotID)"

        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        
        MKMapItem.openMapsWithItems([currentLocation, destLocation], launchOptions: launchOptions)
    }
    
    
    
}
