import UIKit

class EvaluationViewController: UIViewController, UITextFieldDelegate {
    //Outlets, Konstanten und Variablen
    @IBOutlet weak var txtDistance: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtAlpha: UITextField!
    @IBOutlet weak var txtBeta: UITextField!
    @IBOutlet weak var swMode: UISwitch!
    @IBOutlet weak var btnTakeMesurement: UIButton!
    @IBOutlet weak var btnLog: UIButton!
    @IBOutlet weak var svAlpha: UIStackView!
    @IBOutlet weak var svBeta: UIStackView!
    
    var alphaAngle: Double!
    var betaAngle: Double!
    var distance: Double!
    
    //Funktionen
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swMode.setOn(false, animated: false)
        
        enableGuiElements(false)
        txtDistance.delegate = self
        
        if(alphaAngle != nil && betaAngle != nil ) {
            txtDistance.text = String(distance)
            txtAlpha.text = String(alphaAngle)
            txtBeta.text = String(betaAngle)
            checkAngles()
        }
    }
    
    func enableGuiElements(enabled: Bool) {
        svAlpha.hidden = !enabled
        svBeta.hidden = !enabled
        txtDistance.text = ""
        txtHeight.text = ""
        txtAlpha.text = ""
        txtBeta.text = ""
        btnTakeMesurement.enabled = false
        btnLog.enabled = false
    }
    
    func checkAngles() {
        if(!txtAlpha.text!.isEmpty && !txtBeta.text!.isEmpty && !txtDistance.text!.isEmpty) {
            let d: Double! = Double(txtDistance.text)
            let alpha: Double! = Double(txtAlpha.text)
            let beta: Double! = Double(txtBeta.text)
            
            txtHeight.text = String(d * (tan(beta - 90 + alpha) + tan(90 - alpha)))
            
            btnLog.enabled = true
        }
        else {
            txtHeight.text = ""
            btnLog.enabled = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCameraView" {
            let vc = segue.destinationViewController as! MeasureViewController
            vc.distance = distance
        }
    }
    
    //Actions
    @IBAction func changeGuiState(sender: AnyObject) {
        enableGuiElements(swMode.on)
    }
    
    @IBAction func logResult(sender: AnyObject) {
        var json = [String:String]()
        json["task"] = "Groessenmesser"
        
        let solutionLogger = SolutionLogger(viewController: self)
        solutionLogger.scanQRCode { code in
            json["object"] = code
            json["height"] = self.txtHeight.text
            let solutionStr = solutionLogger.JSONStringify(json)
            solutionLogger.logSolution(solutionStr)
        }
    }
    
    @IBAction func angleEdited(sender: AnyObject) {
        checkAngles()
    }
    
    @IBAction func distanceEdited(sender: AnyObject) {
        distance = Double(txtDistance.text!)
        if(!svAlpha.hidden && !svBeta.hidden) {
            checkAngles()
            return
        }
        btnTakeMesurement.enabled = !txtDistance.text!.isEmpty
        if(txtDistance.text!.isEmpty) {
            txtHeight.text = ""
            btnLog.enabled = false
        }
    }
    
    @IBAction func showCameraView(sender: AnyObject) {
        performSegueWithIdentifier("showCameraView", sender: self)
    }
}
