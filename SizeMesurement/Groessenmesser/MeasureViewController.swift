import UIKit
import CoreMotion

class MeasureViewController: UIViewController {
    let motionManager = CMMotionManager()
    
    var cam: BDCamera!
    var currentAngle: Double!
    var alphaAngle: Double!
    var betaAngle: Double!
    var distance: Double!

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var txtAlpha: UITextField!
    @IBOutlet weak var txtBeta: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cam = BDCamera(previewView: cameraView)
        cam.videoGravity =  AVLayerVideoGravityResizeAspectFill
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue()!) { (motion, error) in
            if let attitude = motion?.attitude {
            self.currentAngle = self.radiansToDegrees(attitude.pitch)
            }
        }
        
        // Hier kommt der MotionManager Code rein, mit dem die Winkel
        // gemessen werden können. Den aktuellen Winkel könnt ihr in der 
        // Variable currentAngle zwischenspeichern. Achtung: Die Winkel sind jeweils im
        // Bogenmass und müssen zuerst noch in Grad umgerechnet werden.
        // Eventuell, wollt ihr im GUI noch ein Label auf die Kamera-View
        // setzen, damit ihr darin den aktuell gemessenen Winkel (currentAngle) anzeigen könnt.
    }
    
    private func radiansToDegrees(radians: Double) -> Double {
        return radians * 180 / M_PI
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        alphaAngle = nil
        betaAngle = nil
        cam.startCameraCapture()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        cam.stopCameraCapture()
    }
    
    @IBAction func saveAngle(sender: AnyObject) {
        if(txtAlpha.text!.isEmpty) {
            txtAlpha.text = String(self.currentAngle)
            return
        }
        if(txtBeta.text!.isEmpty) {
            alphaAngle = currentAngle
            performSegueWithIdentifier("showCalculationView", sender: self)
            return
        }
        if(!txtAlpha.text!.isEmpty && !txtBeta.text!.isEmpty) {
            performSegueWithIdentifier("showCalculationView", sender: self)
            return
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCalculationView" {
            let vc = segue.destinationViewController as! EvaluationViewController
            vc.alphaAngle = Double(txtAlpha.text!)
            vc.betaAngle = Double(txtBeta.text!)
            vc.distance = distance
        }
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        let videoOrientation: AVCaptureVideoOrientation
        switch toInterfaceOrientation {
        case .Portrait:
            videoOrientation = .Portrait
        case .PortraitUpsideDown:
            videoOrientation = .PortraitUpsideDown
        case .LandscapeLeft:
            videoOrientation = .LandscapeLeft
        case .LandscapeRight:
            videoOrientation = .LandscapeRight
        default:
            videoOrientation = .Portrait
        }
        
        cam.previewLayer.connection.videoOrientation = videoOrientation
    }
}

