import UIKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    
    let kAccessToken = "sk.eyJ1IjoidG9uaXN1dGVyIiwiYSI6ImNpZmptbnhxYTAxMGR0ZWx4ZjFhejdkMzEifQ.4HxuC8B4MW_slik23J9NqQ"
    let kMapID = "tonisuter.cife1ku4000gmtaknuv49tvwc"
    let kHsrCoordinate = CLLocationCoordinate2DMake(47.223252, 8.817011)
    var kMapView: RMMapView!
    let kLocationManager = CLLocationManager()
    var kCurrentLocationMarker: RMPointAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RMConfiguration.sharedInstance().accessToken = kAccessToken
        kMapView = RMMapView(frame: self.view.bounds, andTilesource: RMMapboxSource(mapID: kMapID)!)
        self.view.addSubview(kMapView)
        
        kCurrentLocationMarker = RMPointAnnotation()
        kCurrentLocationMarker.mapView = kMapView
        kMapView.addAnnotation(kCurrentLocationMarker)
        
        kLocationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            kLocationManager.startUpdatingLocation()
        }
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            kLocationManager.requestAlwaysAuthorization()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        kMapView.zoom = 16
        
        //Laden der Punkte
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            kLocationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        var refresh = false
        
        if kCurrentLocationMarker.coordinate.longitude == 0.0 && kCurrentLocationMarker.coordinate.latitude == 0.0 {
            refresh = true
        }
        
        kCurrentLocationMarker.coordinate = CLLocationCoordinate2DMake(coord.latitude, coord.longitude)
        
        if refresh {
            locate(self)
        }
    }
    
    @IBAction func locate(sender: AnyObject) {
        kMapView.centerCoordinate = kCurrentLocationMarker.coordinate
    }
}
