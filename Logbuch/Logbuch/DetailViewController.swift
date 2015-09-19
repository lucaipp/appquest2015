import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    var logEntry:LogEntry!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = logEntry.solution
        self.title = logEntry.taskName
    }
}