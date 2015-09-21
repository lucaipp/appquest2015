//Tutorial: http://nshipster.com/core-location-in-ios-8/
//Tutorial: http://stackoverflow.com/questions/26741591/how-to-get-current-longitude-and-latitude-using-cllocationmanager-swift

import UIKit
import Foundation
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    //Outlets, Konstanten und Variablen
    @IBOutlet weak var lblGpsState: UILabel!
    @IBOutlet weak var lblGpsLong: UILabel!
    @IBOutlet weak var lblGpsLat: UILabel!
    
    let locationManager = CLLocationManager()
    
    //Funktionen
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        if(CLLocationManager.locationServicesEnabled()) {
            locationManager.startUpdatingLocation()
        }
        
        if(CLLocationManager.authorizationStatus() == .NotDetermined) {
            locationManager.requestAlwaysAuthorization()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if(status == .AuthorizedAlways || status == .AuthorizedWhenInUse) {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lblGpsState.text = "Success"
        
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        
        lblGpsLong.text = "Longitude: \(coord.longitude)"
        lblGpsLat.text = "Latitude: \(coord.latitude)"
    }
    
    //Actions

}

