import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var lblCurrentTarget: UILabel!
    @IBOutlet weak var btnStop: UIButton!
    
    let speechSynthesizer = SpeechSynthesizer()
    var solutionLogger: SolutionLogger!
    var stepCounter: AccelerometerStepCounter!
    var actions: Array<String> = []
    var startStation: Int?
    var isCurrentlyRunning = false
    var processPaused = false

    override func viewDidLoad() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "viewTapped:"))
        self.solutionLogger = SolutionLogger(viewController: self)
        lblCurrentTarget.text = "QR-Code einlesen"
        btnStop.enabled = isCurrentlyRunning
    }
    
    func viewTapped(sender:UITapGestureRecognizer) {
        if !isCurrentlyRunning {
            stepCounter?.stop()
            actions = []
            solutionLogger.scanQRCode { code in
                self.handleQRCode(code)
            }
            return
        }
        
        if processPaused {
            instructionLabel.hidden = true
            processPaused = false
            nextStep()
            return
        }
    }
    
    func handleQRCode(code: String) {
        do {
            guard let data = code.dataUsingEncoding(NSUTF8StringEncoding) else { return }
            guard let dict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String:AnyObject] else { return }
            
            if let input = dict["input"] as? Array<String> {
                self.actions = input
                self.startStation = dict["startStation"] as? Int
                self.instructionLabel.hidden = true
                self.start()
            }
            
            if let endStation = dict["endStation"] as? Int, let startStation = self.startStation {
                let jsonDict = ["task": "Schrittzaehler",
                    "startStation":startStation,
                    "endStation":endStation]
                let json = solutionLogger.JSONStringify(jsonDict)
                solutionLogger.logSolution(json)
//                solutionLogger.logSolution("{\"startStation\":\(startStation),\"endStation\":\(endStation),\"task\":\"Schrittzaehler\"}")
            }
        } catch _ {
            print("Error can't decode JSON")
        }
    }
    
    func startStepCounterWithSteptarget(steps: Int) {
        stepCounter.stepTarget = steps
        stepCounter.onStepTargetReached = {
            self.stepCounter.stop()
            self.stepsLabel.text = "0"
            self.nextStep()
        }
        stepCounter.onStep = {
            self.stepsLabel.text = "\(self.stepCounter.steps)"
        }
        stepCounter.start()
    }
    
    func start() {
        toggleWalkingProcess()
        stepsLabel.text = "0"
        stepCounter = AccelerometerStepCounter()
        stepCounter.onAccelerationMeasured = { (x,y,z,power) in
            self.graphView.addX(0, y: 0, z: power)
        }
        nextStep()
    }
    
    func nextStep() {
        if actions.count > 0 {
            let currentAction = actions[0]
            actions = Array(actions.dropFirst())
            if Int(currentAction) != nil {
                speakAction(String("Laufe \(currentAction) Schritte"))
                startStepCounterWithSteptarget(Int(currentAction)!)
            }
            else {
                speakAction(String("Drehe dich nach \(currentAction)"))
                instructionLabel.hidden = false
                instructionLabel.text = "Berühren um fortzufahren"
                processPaused = true
            }
        }
        else {
            stopProcess(self)
        }
    }
    
    func speakAction (action: String) {
        lblCurrentTarget.text = action
        speechSynthesizer.speak(lblCurrentTarget.text!)
    }
    
    func toggleWalkingProcess () {
        isCurrentlyRunning = !isCurrentlyRunning
        btnStop.enabled = !btnStop.enabled
    }
    
    @IBAction func stopProcess(sender: AnyObject) {
        stepCounter?.stop()
        actions = []
        toggleWalkingProcess()
        stepsLabel.text = String("")
        instructionLabel.hidden = false
        speakAction("QR-Code einlesen")
    }
}

