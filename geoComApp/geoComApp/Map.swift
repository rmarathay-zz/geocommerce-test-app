//
//  Map.swift
//  geoComApp
//
//  Created by Ranjit Marathay on 11/25/16.
//  Copyright © 2016 Ranjit Marathay. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Stripe
import Firebase
import FBSDKLoginKit
import Alamofire
import AFNetworking

class Map: UIViewController, CLLocationManagerDelegate{
    
    let ref = FIRDatabase.database().reference()
    var currentLocation = CLLocation()
    var locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    @IBOutlet weak var map: MKMapView!
    
    @IBAction func purchaseButton(_ sender: Any) {
        //let dataRef = self.ref.child("users").child(MainData.username);
//        let key = self.ref.child("payments/\(MainData.username)/").childByAutoId().key
//        print(key)
        let loc:[String: String] = ["latitute" : String(currentLocation.coordinate.latitude), "longitude" : String(currentLocation.coordinate.longitude), "dollar" : "10", "time" : String(describing: NSDate())]
        let updates = ["payments/\(MainData.username)" : loc];
         
        ref.updateChildValues(updates);
        MainData.data.append(loc)
    }
    
    @IBAction func addcardButton(_ sender: Any) {
        // Just for a segue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self;
        locationManager.requestAlwaysAuthorization();
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.startMonitoringSignificantLocationChanges();
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                    regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let last = locations.count - 1
        //let second = locations.count - 2
        currentLocation = locations[last]
        let centerLocation = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude);
        let regionSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005);
        let regionLocation = MKCoordinateRegion(center: centerLocation, span: regionSpan);
        self.map.setRegion(regionLocation, animated: true);
        let mainAnno = MKPointAnnotation();
        //if(
        mainAnno.coordinate = centerLocation;
        self.map.addAnnotation(mainAnno);
    }
    
    
}
