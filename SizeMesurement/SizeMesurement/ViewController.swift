import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
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
    
    //Funktionen
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swMode.setOn(false, animated: false)
        txtDistance.delegate = self
        
        txtDistance.keyboardType = .NumberPad
        txtAlpha.delegate = self
        txtAlpha.keyboardType = .NumberPad
        txtBeta.delegate = self
        txtBeta.keyboardType = .NumberPad
        
        enableGuiElements(false)
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
            btnTakeMesurement.enabled = true
        }
        else {
            btnTakeMesurement.enabled = false
        }
    }
    
    //Actions
    @IBAction func changeGuiState(sender: AnyObject) {
        enableGuiElements(swMode.on)
    }
    
    @IBAction func textEdited(sender: AnyObject) {
        if(!txtHeight.text!.isEmpty && !txtHeight.text!.isEmpty) {
            btnLog.enabled = true
        }
        else {
            btnLog.enabled = false
        }
    }
    
    @IBAction func mesurementStarted(sender: AnyObject) {
        //Aufgrund von swMode entscheiden, ob Winkel noch gemessen werden müssen
        
        //Berechnung vornehmen
        
        txtHeight.text = String(3.0)
        btnLog.enabled = true
    }
    
    @IBAction func logResult(sender: AnyObject) {
        var json = [String:String]()
        json["task"] = "Grössenmesser"
        json["height"] = txtHeight.text
        
        let solutionLogger = SolutionLogger(viewController: self)
        let solutionStr = solutionLogger.JSONStringify(json)
        solutionLogger.logSolution(solutionStr)
    }
    
    @IBAction func angleEdited(sender: AnyObject) {
        checkAngles()
    }
    
    @IBAction func distanceEdited(sender: AnyObject) {
        if(!svAlpha.hidden && !svBeta.hidden) {
            checkAngles()
            if(txtDistance.text!.isEmpty) {
                btnLog.enabled = false
            }
            return
        }
        btnTakeMesurement.enabled = !txtDistance.text!.isEmpty
        if(txtDistance.text!.isEmpty) {
            btnLog.enabled = false
        }
    }
}

