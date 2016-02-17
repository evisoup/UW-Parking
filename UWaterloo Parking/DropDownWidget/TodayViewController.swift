//
//  TodayViewController.swift
//  DropDownWidget
//
//  Created by 刘恒邑 on 16/2/17.
//  Copyright © 2016年 Hengyi Liu. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    

    @IBOutlet var cCap: UILabel!
    @IBOutlet var nCap: UILabel!
    @IBOutlet var wCap: UILabel!
    @IBOutlet var xCap: UILabel!
    
    @IBOutlet var cPst: UILabel!
    @IBOutlet var nPst: UILabel!
    @IBOutlet var wPst: UILabel!
    @IBOutlet var xPst: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        
        self.preferredContentSize = CGSizeMake(0, 200);
        completionHandler(NCUpdateResult.NewData)
    }
    
    
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
                                let cap = data["capacity"] as? Int else{break}
                            
                            dispatch_async(dispatch_get_main_queue()){
                                switch name{
                                case "C" :
                                    self.cCap.text = "\(count) / \(cap)"
                                    self.cPst.text = "\(pct)%"
                                    
                                case "N" :
                                    self.nCap.text = "\(count) / \(cap)"
                                    self.nPst.text = "\(pct)%"
                                    
                                case "X" :
                                    self.xCap.text = "\(count) / \(cap)"
                                    self.xPst.text = "\(pct)%"
                                    
                                case "W" :
                                    self.wCap.text = "\(count) / \(cap)"
                                    self.wPst.text = "\(pct)%"
                                    
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
    
}
