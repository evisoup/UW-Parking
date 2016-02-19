//
//  ViewController.swift
//  MapPages
//
//  Created by Huiwen You on 2016-02-12.
//  Copyright © 2016 FORCE. All rights reserved.
//

import UIKit
import MapKit

//class parkingLots: NSObject, MKAnnotation {
//    var lotName: String?
//    var coordinate: CLLocationCoordinate2D
//    var currentCount: Int
//    var capacity: Int
//
//    init(lotName: String, coordinate: CLLocationCoordinate2D, currentCount: Int, capacity: Int) {
//        self.lotName = lotName
//        self.coordinate = coordinate
//        self.currentCount = currentCount
//        self.capacity = capacity
//    }
//}

class MapViewController: UIViewController, MKMapViewDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var mapContainer: MKMapView!
    
    var latC: CLLocationDegrees = 0.0
    var longC: CLLocationDegrees = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let latitude:CLLocationDegrees = 43.472761
        let longitude:CLLocationDegrees = -80.542164
        
        //zoom in degree less: zoom+
        let latDelta:CLLocationDegrees = 0.02
        let longDelta:CLLocationDegrees = 0.02
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta,longDelta)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        mapContainer.delegate = self
        
        mapContainer.setRegion(region, animated: true)
        //mapContainer.showsUserLocation = true
        mapContainer.showsCompass = true
        
        self.setParkingLot("C")
        self.setParkingLot("N")
        self.setParkingLot("W")
        self.setParkingLot("X")
        
    }
    
    //    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    //
    //        //Define a reuse identifier. This is a string that will be used to ensure we reuse annotation views as much as possible.
    //
    //        let reuseId = "mapPin"
    //
    //        print("debug")
    //
    //        //Check whether the annotation we're creating a view for is one of our parkingLots objects.
    //        if annotation.isKindOfClass(parkingLots.self) {
    //            // Try to dequeue an annotation view from the map view's pool of unused views.
    //            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
    //
    //            if annotationView == nil {
    //                print("debug2")
    //                //If it isn't able to find a reusable view, create a new one using MKPinAnnotationView and sets its canShowCallout property to be true. This triggers the popup with the city name.
    //                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
    //
    //                //annotationView!.canShowCallout = true
    //
    //                //Create a new UIButton using the built-in .DetailDisclosure type. This is a small blue "i" symbol with a circle around it.
    //                let btn = UIButton(type: .DetailDisclosure)
    //
    //                annotationView!.rightCalloutAccessoryView = btn
    //            } else {
    //                print("debug3")
    //                //If it can reuse a view, update that view to use a different annotation.
    //                annotationView!.annotation = annotation
    //            }
    //            print("debug4")
    //            return annotationView
    //        }
    //
    //        //If the annotation isn't a parkinglot, it must return nil so iOS uses a default view.
    //        return nil
    //        print("debug5")
    //    }
    
    func setParkingLot(lot: String) {
        let annotation = MKPointAnnotation()
        
        RestApiManager.sharedInstance.getParkingLotLocation(lot) {
            (latitude: Double, longitude: Double) in
            RestApiManager.sharedInstance.getCurrentCountAndCapacity(lot) {
                (count: Int, capacity: Int) in
                dispatch_async(dispatch_get_main_queue(),{
                    let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                    
                    //                    let lotAnnotation = parkingLots(lotName: lot, coordinate: location, currentCount: count, capacity: capacity)
                    
                    annotation.coordinate = location
                    annotation.title = lot
                    if count == -1 || capacity == -1 {
                        annotation.subtitle = "Data not available!"
                    } else {
                        annotation.subtitle = "\(count) / \(capacity)"
                    }
                    
                    //self.mapContainer.addAnnotation(lotAnnotation)
                    self.mapContainer.addAnnotation(annotation)
                    
                    //                    let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
                    //
                    //                    uilpgr.minimumPressDuration = 2
                    //                    
                    //                    self.mapContainer.addGestureRecognizer(uilpgr)
                    
                })
            }
        }
    }
}

