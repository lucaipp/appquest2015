import UIKit
import CoreLocation

class MapViewController: UIViewController {
    let kAccessToken = "sk.eyJ1IjoidG9uaXN1dGVyIiwiYSI6ImNpZmptbnhxYTAxMGR0ZWx4ZjFhejdkMzEifQ.4HxuC8B4MW_slik23J9NqQ"
    let kMapID = "tonisuter.cife1ku4000gmtaknuv49tvwc"
    let kHsrCoordinate = CLLocationCoordinate2DMake(47.223252, 8.817011)
    var kMapView: RMMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RMConfiguration.sharedInstance().accessToken = kAccessToken
        kMapView = RMMapView(frame: self.view.bounds, andTilesource: RMMapboxSource(mapID: "mapbox.run-bike-hike")!)
        self.view.addSubview(kMapView)
        
        kMapView.zoom = 15
        kMapView.centerCoordinate = kHsrCoordinate
        // Hier sollte der locationManager konfiguriert und gestartet werden.
        // Zusätzlich muss der MapViewController das CLLocationManagerDelegate-Protokoll
        // implementieren, damit die Location-Updates empfangen werden können.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Hier soll die MapView konfiguriert werden.
        // Zum Beispiel kann man den Zoom-Level oder 
        // die center coordinate setzen.
    }
}
