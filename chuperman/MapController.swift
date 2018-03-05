//
//  MapController.swift
//  chuperman
//
//  Created by Cesar Saravia on 2/2/18.
//  Copyright © 2018 Cesar Saravia. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate/*,UISearchBarDelegate*/ {

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
   
    var geoCoder : CLGeocoder!
    var locationManager = CLLocationManager()
    var previousAddress: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        geoCoder = CLGeocoder()
        self.mapView.delegate = self
        
    }
    
  /*  @IBAction func SearchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
        
        
        
    }*/
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location  = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        let mylocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let reg = MKCoordinateRegionMake(mylocation, span)
        self.mapView.setRegion(reg, animated: true)
        self.mapView.showsUserLocation = true
        
        geoCode(location: location)
        
    }
    
    func mapView(_ MapView: MKMapView, regionDidChangeAnimated animated: Bool){
        let location = CLLocation(latitude: MapView.centerCoordinate.latitude, longitude: MapView.centerCoordinate.longitude)
        geoCode(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func geoCode(location : CLLocation){
            geoCoder.cancelGeocode()
            geoCoder.reverseGeocodeLocation(location, completionHandler: {(data,error) -> Void in
            guard let placeMarks = data as [CLPlacemark]! else {
                    return
            }
            
            let loc: CLPlacemark = placeMarks[0]
            let addressDict : [NSString:NSObject] = loc.addressDictionary as! [NSString:NSObject]
            let addrList = addressDict["FormattedAddressLines"] as! [String]
            let address = "\(addrList)" //" ".join(addrList)
            print(self.address)
            self.address.text = address
            self.previousAddress = address
            
        })
    }
}
