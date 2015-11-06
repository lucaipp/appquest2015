import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var graphView: GraphView!
    
    let speechSynthesizer = SpeechSynthesizer()
    var solutionLogger: SolutionLogger!
    var stepCounter: AccelerometerStepCounter!
    var actions: Array<String> = []
    var startStation: Int?

    override func viewDidLoad() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "viewTapped:"))
        self.solutionLogger = SolutionLogger(viewController: self)
    }
    
    func viewTapped(sender:UITapGestureRecognizer) {
        stepCounter?.stop()
        actions = []
        solutionLogger.scanQRCode { code in
            self.handleQRCode(code)
        }
    }
    
    func handleQRCode(code: String) {
        do {
            guard let data = code.dataUsingEncoding(NSUTF8StringEncoding) else { return }
            guard let dict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String:AnyObject] else { return }
            
            if let input = dict["input"] as? Array<String> {
                self.actions = input
                self.startStation = dict["startStation"] as? Int
                self.start()
            }
            
            if let endStation = dict["endStation"] as? Int, let startStation = self.startStation {
                //TODO: Logge die Lösung im Logbuch mit Hilfe des SolutionLoggers
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
        stepsLabel.text = "0"
        stepCounter = AccelerometerStepCounter()
        stepCounter.onAccelerationMeasured = { (x,y,z,power) in
            self.graphView.addX(0, y: 0, z: power)
        }
        
        nextStep()
    }
    
    func nextStep() {
        // TODO: Nehme die nächste Action aus dem actions-Array und gebe sie mit Hilfe des SpeechSynthesizers aus
    }
}

