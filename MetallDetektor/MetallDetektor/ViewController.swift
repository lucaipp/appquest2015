import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var isCurrentlyRunning = false
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var pvMessurement: UIProgressView!
    @IBOutlet weak var btnTriggerMesurement: UIButton!
    @IBOutlet weak var lblValue: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.headingFilter = kCLHeadingFilterNone
        locationManager.delegate = self
        
        lblValue.text = String(0.0)
    }
    
    @IBAction func btnTriggerMesurementClicked(sender: AnyObject) {
        if(isCurrentlyRunning) {
            locationManager.stopUpdatingHeading()
            pvMessurement.setProgress(0.0, animated: true)
            isCurrentlyRunning = false
            btnTriggerMesurement.setTitle("Messung starten", forState: .Normal)
        }
        else {
            isCurrentlyRunning = true
            locationManager.startUpdatingHeading()
            btnTriggerMesurement.setTitle("Messung stoppen", forState: .Normal)
        }
    }
    
    @IBAction func btnLogClicked(sender: AnyObject) {
        var json = [String:String]()
        json["task"] = "Metalldetektor"
        
        let solutionLogger = SolutionLogger(viewController: self)
        solutionLogger.scanQRCode { code in
            json["solution"] = code
            let solutionStr = solutionLogger.JSONStringify(json)
            solutionLogger.logSolution(solutionStr)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let x = newHeading.x
        let y = newHeading.y
        let z = newHeading.z
        
        let magnitude:Double = sqrt((x*x) + (y*y) + (z*z))
        let magnitudeRatio: Float = Float(magnitude) / 4000.0
        lblValue.text = String(magnitudeRatio)
        
        pvMessurement.setProgress(magnitudeRatio, animated: true)
    }
}

