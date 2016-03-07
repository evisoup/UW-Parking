//
//  ViewController.swift
//  searchtab
//
//  Created by Phoenix on 2016-02-18.
//  Copyright © 2016 Phoenix. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet var buildingTable: UITableView!
    
    @IBOutlet var selectInfo: UILabel!
    
    @IBOutlet var lotInfo: UILabel!

    @IBOutlet var traveltimeInfo: UILabel!

    
    struct Building {
        var name: String
        var code: String
        var latitude: Double
        var longitude: Double
    }
    
    var buildinglist = [Building]()
    var filteredData: [Building]!
    
    struct Lot {
        var name: String
        var latitude: Double
        var longitude: Double
        
    }
    
    var lotlist = [Lot]()
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildingTable.dataSource = self
        filteredData = Buildingdata
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        buildingTable.tableHeaderView = searchController.searchBar
        
        
        searchController.searchBar.placeholder = "Get Walking Estimate"
        
        searchController.searchBar.layer.borderColor = UIColor(red: 252/255.0, green: 212/255.0, blue: 80/255.0, alpha: 1.0).CGColor
        searchController.searchBar.layer.borderWidth = 1
        searchController.searchBar.barTintColor = UIColor(red: 252/255.0, green: 212/255.0, blue: 80/255.0, alpha: 1.0)
        searchController.searchBar.tintColor = UIColor.blackColor()
        
                navigationItem.titleView = searchController.searchBar
                searchController.hidesNavigationBarDuringPresentation = false
        
        definesPresentationContext = true

        
        RestApiManager.sharedInstance.getParkingData { json in
            let lotResult = json["data"]

            for (index: _, subJson: Json) in lotResult {
                self.lotlist.append(Lot(name:Json["lot_name"].string!, latitude:Json["latitude"].doubleValue, longitude:Json["longitude"].doubleValue))
            }
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = buildingTable.dequeueReusableCellWithIdentifier("buildingcell")! as UITableViewCell
        cell.textLabel?.text = filteredData[indexPath.row].code + " - " + filteredData[indexPath.row].name
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let searchCode = self.filteredData[indexPath.row].code
        let searchLatitude = self.filteredData[indexPath.row].latitude
        let searchLongitude = self.filteredData[indexPath.row].longitude
        searchController.active = false
        searchController.searchBar.resignFirstResponder()
        
        self.selectInfo.text = searchCode
        self.lotInfo.text = "Searching . . ."
        self.traveltimeInfo.text = ""
        
        var tmpTime = 0.0
        var tmpLot:String = ""
        var tmpRequestTime = 0.0
        var notprint = false
        
        if (searchLatitude == 0.0 || searchLongitude == 0.0) {
            notprint = true
            self.selectInfo.text = searchCode
            self.lotInfo.text = "not available"
            return
        } else {
            
            let markSelection = MKPlacemark(coordinate: CLLocationCoordinate2DMake(searchLatitude, searchLongitude), addressDictionary: nil)
            
            
            for index in 0..<self.lotlist.count {
                let markDestLot = MKPlacemark(coordinate: CLLocationCoordinate2DMake(self.lotlist[index].latitude, self.lotlist[index].longitude), addressDictionary: nil)
                
                let request = MKDirectionsRequest()
                request.source = MKMapItem(placemark: markSelection)
                request.destination = MKMapItem(placemark: markDestLot)
                request.transportType = .Walking
                
                let direction = MKDirections(request: request)
                direction.calculateETAWithCompletionHandler { response, error -> Void in
                    if let err = error {
                        self.selectInfo.text = searchCode
                        self.lotInfo.text = "not available"
                        self.traveltimeInfo.text = ""
                        notprint = true
                        return
                    }
                    tmpRequestTime = response!.expectedTravelTime/60
     
                    if index == 0 {
                        tmpTime = tmpRequestTime
                        tmpLot = self.lotlist[index].name
                    } else if tmpRequestTime < tmpTime {
                        tmpTime = tmpRequestTime
                        tmpLot = self.lotlist[index].name
                    }
                }
                
            }
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                if (!notprint) {
                    self.selectInfo.text = searchCode
                    if (tmpLot == "" || Int(round(tmpTime)) == 0) {
                        self.lotInfo.text = "Please try again"
                        self.traveltimeInfo.text = ""
                    } else {
                        self.lotInfo.text = "\(tmpLot) "
                        let displayTime = Int(round(tmpTime))
                        self.traveltimeInfo.text = "\(displayTime) minutes"
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func top(sender: AnyObject) {
        buildingTable.setContentOffset(CGPoint.zero, animated:true)
    }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.selectInfo.text = ""
        self.lotInfo.text = ""
        self.traveltimeInfo.text = ""
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? Buildingdata : Buildingdata.filter({
                return ($0.name.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil) || ($0.code.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil)
            })
            
            buildingTable.reloadData()
        }
        buildingTable.setContentOffset(CGPoint.zero, animated:true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}

