import UIKit

class MainViewController: UIViewController {
    var pixelGrid: PixelGridView!
    let gridColor = UIColor(rgba: "#d1d1d1ff")
    let gridSize = 11
    var selectedColor = UIColor.clearColor()
    let colors = [UIColor(rgba: "#1364b7FF"), UIColor(rgba: "#13b717FF"), UIColor(rgba: "#ffea00FF"), UIColor(rgba: "#000000FF"), UIColor.clearColor()]
    var solutionLogger: SolutionLogger!
    
    @IBOutlet weak var touchView: TouchTrackerView!
    @IBOutlet weak var color1ControlView: ColorControlView!
    @IBOutlet weak var color2ControlView: ColorControlView!
    @IBOutlet weak var color3ControlView: ColorControlView!
    @IBOutlet weak var color4ControlView: ColorControlView!
    @IBOutlet weak var color5ControlView: ColorControlView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initColorControls()
        
        pixelGrid = PixelGridView(gridSize: gridSize, gridColor: gridColor)
        pixelGrid.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(pixelGrid, belowSubview: touchView)
        let c1 = NSLayoutConstraint(item: pixelGrid, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: touchView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        let c2 = NSLayoutConstraint(item: pixelGrid, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: touchView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        let c3 = NSLayoutConstraint(item: pixelGrid, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: touchView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let c4 = NSLayoutConstraint(item: pixelGrid, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: touchView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.view.addConstraints([c1, c2, c3, c4])
        
        touchView.onPathDrawn = { points in
            self.pixelGrid.colorizeSquaresOnPath(points, color: self.selectedColor)
        }
        
        solutionLogger = SolutionLogger(viewController: self)
    }
    
    func initColorControls() {
        let controls = [color1ControlView, color2ControlView, color3ControlView, color4ControlView, color5ControlView]
        
        for (index,control) in controls.enumerate() {
            control.backgroundColor = colors[index]
            control.onSelect = {
                for controlToBeDisabled in controls {
                    controlToBeDisabled.isControlSelected = false
                }
                control.isControlSelected = true
                self.selectedColor = control.backgroundColor!
            }
        }
    }
    
    @IBAction func clearGrid(sender: AnyObject) {
        pixelGrid.clearSquares()
    }
    
    @IBAction func logResult(sender: AnyObject) {
        // TODO: log the result in the logbook in the required format
        var jsonRows: [AnyObject] = []
        for var x = 0; x < pixelGrid.squares.count; x++ {
            for var y = 0; y < pixelGrid.squares[x].count; y++ {
                let jsonRow = ["y":String(y),"x":String(x),"color":(pixelGrid.squares[x][y].backgroundColor?.rgbaHexString())!]
                jsonRows.append(jsonRow)
            }
        }
        let jsonDict = ["task": "Pixelmaler", "pixels": jsonRows]
        
        solutionLogger.logSolution(solutionLogger.JSONStringify(jsonDict))
    }
}
