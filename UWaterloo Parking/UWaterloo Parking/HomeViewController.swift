//
//  HomeViewController.swift
//  UWaterloo Parking
//
//  Created by 刘恒邑 on 16/2/17.
//  Copyright © 2016年 Hengyi Liu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var actind: UIActivityIndicatorView!
//    var screenwidth:CGFloat = 0.0;
//    var screenheight:CGFloat = 0.0;
    
    @IBOutlet var cCap: UILabel!
    @IBOutlet var cPct: UILabel!
    
    @IBOutlet var nCap: UILabel!
    @IBOutlet var nPct: UILabel!
    
    @IBOutlet var wCap: UILabel!
    @IBOutlet var wPct: UILabel!
    
    @IBOutlet var xCap: UILabel!
    @IBOutlet var xPct: UILabel!
    
    
    @IBAction func toMap(sender: AnyObject) {
        tabBarController?.selectedIndex = 1
    }
    
    
    @IBAction func myRefresh(sender: AnyObject) {
        actind.startAnimating()
        update()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "UWATERLOO PARKING"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterForground", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        update()
    }
    
    func willEnterForground() {
        update()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "cDetails" ){
            if let destinationVC = segue.destinationViewController as? LotsDetailController{
                destinationVC.lotID  =  "C"
            }
        }
        
        if(segue.identifier == "nDetails" ){
            if let destinationVC = segue.destinationViewController as? LotsDetailController{
                destinationVC.lotID  =  "N"
            }
        }
        
        if(segue.identifier == "xDetails" ){
            if let destinationVC = segue.destinationViewController as? LotsDetailController{
                destinationVC.lotID  =  "X"
            }
        }
        
        if(segue.identifier == "wDetails" ){
            if let destinationVC = segue.destinationViewController as? LotsDetailController{
                destinationVC.lotID  =  "W"
            }
        }
        
        
        
    }
    
    
    func update() {
        
        let url = NSURL(string: "https://api.uwaterloo.ca/v2/parking/watpark.json?key=")!
        
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
                                let cap = data["capacity"] as? Int else{break}
                            
                            dispatch_async(dispatch_get_main_queue()){
                                switch name{
                                case "C" :
                                    self.cCap.text = "\(count) / \(cap)"
                                    self.cPct.text = "\(pct)%"
                                    
                                case "N" :
                                    self.nCap.text = "\(count) / \(cap)"
                                    self.nPct.text = "\(pct)%"
                                    
                                case "X" :
                                    self.xCap.text = "\(count) / \(cap)"
                                    self.xPct.text = "\(pct)%"
                                    
                                case "W" :
                                    self.wCap.text = "\(count) / \(cap)"
                                    self.wPct.text = "\(pct)%"
                                    
                                default:
                                    break
                                }
                                self.actind.stopAnimating()
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
    



}
