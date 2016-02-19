//
//  LotsDetailController.swift
//  UWaterloo Parking
//
//  Created by 刘恒邑 on 16/2/17.
//  Copyright © 2016年 Hengyi Liu. All rights reserved.
//

import UIKit

class LotsDetailController: UIViewController {
    
    
    
    @IBOutlet var lotCap: UILabel!
    @IBOutlet var lotPct: UILabel!
    @IBOutlet var lotTime: UILabel!
    @IBOutlet var lotName: UILabel!
    
    
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
                                let t = data["last_updated"] as? String,
                                let cap = data["capacity"] as? Int else{break}
                            
                            dispatch_async(dispatch_get_main_queue()){
                                switch name{
                                case self.lotID :
                                    self.lotCap.text = "\(count) / \(cap)"
                                    self.lotPct.text = "\(pct)%"
                                    self.lotTime.text = t
                                    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterForground", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        update()
        lotName.text = lotID

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
    }
    func willEnterForground() {
        update()
    }
    



}
