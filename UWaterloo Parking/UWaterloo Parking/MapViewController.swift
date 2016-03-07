//
//  ViewController.swift
//  MapPages
//
//  Created by Huiwen You on 2016-02-12.
//  Copyright © 2016 FORCE. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var mapContainer: MKMapView!
    
    var latC: CLLocationDegrees = 0.0
    var longC: CLLocationDegrees = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let latitude:CLLocationDegrees = 43.472761
        let longitude:CLLocationDegrees = -80.542164
        
        let latDelta:CLLocationDegrees = 0.02
        let longDelta:CLLocationDegrees = 0.02
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta,longDelta)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        mapContainer.delegate = self
        
        mapContainer.setRegion(region, animated: true)
        mapContainer.showsUserLocation = true
        mapContainer.showsCompass = true
        
        self.setParkingLot("C")
        self.setParkingLot("N")
        self.setParkingLot("W")
        self.setParkingLot("X")
        
    }
    
    func mapView(mapView: MKMapView,
        viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
            
            if !(annotation is CustomPointAnnotation) {
                //return nil so map view draws "blue dot" for standard user location
                return nil
            }
            
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as MKAnnotationView!
            if pinView == nil {
                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.enabled = true

                let btn = UIButton(type: .DetailDisclosure)
                pinView!.rightCalloutAccessoryView = btn
            }
            else {
                pinView!.annotation = annotation
            }
            
            let cpa = annotation as! CustomPointAnnotation
            pinView!.image = UIImage(named:cpa.imageName)
            
            return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        let customedPin = view.annotation
        let lotName = customedPin!.title!
        let data = customedPin!.subtitle!
        
        let ac = UIAlertController(title: lotName, message: data!, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(
            title: "Navigate Here", style: UIAlertActionStyle.Default, handler: { action in
                
                let currentLocation = MKMapItem.mapItemForCurrentLocation()
                
                let markDestLocation = MKPlacemark(coordinate: CLLocationCoordinate2DMake((customedPin!.coordinate.latitude), (customedPin!.coordinate.longitude)), addressDictionary: nil)
                let destLocation = MKMapItem(placemark: markDestLocation)
                
                destLocation.name = "UWaterloo Parking Lot: \(lotName)"
                
                let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                MKMapItem.openMapsWithItems([currentLocation, destLocation], launchOptions: launchOptions)
            }
            ))
        ac.addAction(UIAlertAction(
            title: "Cancel", style: UIAlertActionStyle.Default, handler: { action in
                ac.dismissViewControllerAnimated(true, completion: nil)
            }
        ))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    
    func setParkingLot(lot: String) {
        let annotation = CustomPointAnnotation()
        
        RestApiManager.sharedInstance.getParkingLotLocation(lot) {
            (latitude: Double, longitude: Double) in
            RestApiManager.sharedInstance.getCurrentCountAndCapacity(lot) {
                (count: Int, capacity: Int) in
                dispatch_async(dispatch_get_main_queue(),{
                    let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                    
                    annotation.coordinate = location
                    annotation.title = "Parking Lot: \(lot)"
                    
                    if count == -1 || capacity == -1 {
                        annotation.subtitle = "Data not available!"
                    } else {
                        annotation.subtitle = "\(count) / \(capacity)"
                    }
                    
                    if (lot == "C") {
                        annotation.imageName = "iconc.png"
                    }
                    if (lot == "N") {
                        annotation.imageName = "iconn.png"
                    }
                    if (lot == "W") {
                        annotation.imageName = "iconw.png"
                    }
                    if (lot == "X") {
                        annotation.imageName = "iconx.png"
                    }
                    
                    self.mapContainer.addAnnotation(annotation)
                    
                })
            }
        }
    }
}


class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}