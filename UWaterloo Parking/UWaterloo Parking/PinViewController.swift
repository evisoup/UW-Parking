//
//  ViewController.swift
//  pinMyLocation
//
//  Created by Huiwen You on 2016-02-16.
//  Copyright © 2016 FORCE. All rights reserved.
//

import UIKit
import MapKit

class PinViewController: UIViewController, CLLocationManagerDelegate {
    
    var manager: CLLocationManager!
    var userLocation: CLLocation!
    var dropPin: Bool = false
    var myCarLatitude: CLLocationDegrees = 0.00
    var myCarLongitude: CLLocationDegrees = 0.00
    
    @IBOutlet weak var mapContainer: MKMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        let latitude: CLLocationDegrees = 43.47134906
//        let longitude: CLLocationDegrees = -80.54270285
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
//        userLocation = locations[0]
//        
//        let latitude = userLocation.coordinate.latitude
//        
//        let longitude = userLocation.coordinate.longitude
//        
//        let latDelta:CLLocationDegrees = 0.05
//        let longDelta:CLLocationDegrees = 0.05
//        
//        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
//        
//        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta,longDelta)
//        
//        let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
//        
//        
//        
//        
        
        mapContainer.showsUserLocation = true
        mapContainer.showsCompass = true
        mapContainer.showsBuildings = true
        //mapContainer.setRegion(region, animated: true)
        
    }
    
    
    @IBAction func pin(sender: AnyObject) {
        //print("it worked")
        
        //        let curLat = 43.47134906
        //        let curLong = -80.54270285
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        dropPin = true
        
        //print("debug 1")
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        //print("debug 3")
        
        userLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        
        let longitude = userLocation.coordinate.longitude
        
        //let latitude: CLLocationDegrees = 43.47134906
        //let longitude: CLLocationDegrees = -80.54270285
        
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta,longDelta)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        
        mapContainer.showsUserLocation = true
        mapContainer.showsCompass = true
        mapContainer.showsBuildings = true
        mapContainer.setRegion(region, animated: true)
        
        if (dropPin) {
            let annotation = MKPointAnnotation()
            myCarLatitude = latitude
            myCarLongitude = longitude
            annotation.coordinate = coordinate
            annotation.title = "MyCarLocation"
            annotation.subtitle = "\(latitude) / \(longitude)"
            
            self.mapContainer.addAnnotation(annotation)
        }
        manager.stopUpdatingLocation()
        
    }
    
    func centerMapOnMyCarLocation() {
        
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta,longDelta)
        
        if (myCarLatitude != 0.00 && myCarLongitude != 0.00) {//car location pinned
            let coordinate = CLLocationCoordinate2DMake(myCarLatitude,
                myCarLongitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
            mapContainer.setRegion(region, animated: true)
        }         
        
    }
    
    @IBAction func findCarBtn(sender: AnyObject) {
        
        centerMapOnMyCarLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

