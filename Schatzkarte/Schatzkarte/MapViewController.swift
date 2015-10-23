import UIKit
import CoreLocation

class MapViewController: UIViewController {
    let kAccessToken = "<Access-Token aus der Aufgabenstellung>"
    let kMapID = "tonisuter.cife1ku4000gmtaknuv49tvwc"
    let kHsrCoordinate = CLLocationCoordinate2DMake(47.223252, 8.817011)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RMConfiguration.sharedInstance().accessToken = kAccessToken
        
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
