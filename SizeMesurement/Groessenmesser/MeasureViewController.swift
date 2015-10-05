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
                if(motion?.gravity.z < 0.0) {
                    self.currentAngle = self.radiansToDegrees(attitude.pitch)
                }
                if(motion?.gravity.z == 0.0) {
                    self.currentAngle = 90.0
                }
                if(motion?.gravity.z > 0.0) {
                    self.currentAngle = 90.0 + (90.0 - self.radiansToDegrees(attitude.pitch))
                }
            }
        }
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
        if(currentAngle < 0.0 || currentAngle > 180.0) {
<<<<<<< HEAD
            
=======
            let alert = UIAlertController(title: "Messfehler!", message:
                "Der gemessene Winkel ist nicht möglich", preferredStyle: UIAlertControllerStyle.Alert)
            
            self.presentViewController(alert, animated: false, completion: nil)
            
            alert.addAction(UIAlertAction(title: "Reset", style: UIAlertActionStyle.Default,
                handler: {action in
                    self.resetPressed(self)
            }))
>>>>>>> master
        }
        if(txtAlpha.text!.isEmpty) {
            alphaAngle = currentAngle
            txtAlpha.text = String(alphaAngle)
            return
        }
        if(txtBeta.text!.isEmpty) {
            betaAngle = currentAngle - alphaAngle
            txtBeta.text = String(betaAngle)
            performSegueWithIdentifier("showCalculationView", sender: self)
            return
        }
        if(!txtAlpha.text!.isEmpty && !txtBeta.text!.isEmpty) {
            performSegueWithIdentifier("showCalculationView", sender: self)
            return
        }
        
    }
    
    @IBAction func resetPressed(sender: AnyObject) {
        alphaAngle = nil
        txtAlpha.text = ""
        betaAngle = nil
        txtBeta.text = ""
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

