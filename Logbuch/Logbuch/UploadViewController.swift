import UIKit

class UploadViewController: UIViewController, UITextFieldDelegate {
    let kAppQuestTeamNameKey = "AppQuestTeamName"
    let kAppQuestTeamCodeKey = "AppQuestTeamCode"
    let kUploadUrl = "http://appquest.hsr.ch/admin/entries/create"
    
    var logEntries = [LogEntry]()
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var teamCodeTextField: UITextField!
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let appQuestTeamName = defaults.objectForKey(kAppQuestTeamNameKey) as? String
        let appQuestTeamCode = defaults.objectForKey(kAppQuestTeamCodeKey) as? String
        
        if let teamName = appQuestTeamName {
            teamNameTextField.text = teamName
        }
        if let teamCode = appQuestTeamCode {
            teamCodeTextField.text = teamCode
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func performUpload(sender: AnyObject) {
        let hud = MBProgressHUD.showHUDAddedTo(self.contentView, animated: true)
        hud.labelText = NSLocalizedString("UploadMessage", comment: "")
        
        var parameters = ["teamName":self.teamNameTextField.text!, "teamCode":self.teamCodeTextField.text!]
        for (i, logEntry) in logEntries.enumerate() {
            parameters[String(format: "entries[%lu].text", i)] = logEntry.solution
            parameters[String(format: "entries[%lu].date", i)] = logEntry.formattedTimeStamp
        }
        
        let manager = AFHTTPRequestOperationManager()
        let uploadURL = NSURL(string: kUploadUrl)!
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.POST(uploadURL.absoluteString,
            parameters: parameters,
            success: { operation, responseObject in
                let message = String(data: responseObject as! NSData, encoding: NSUTF8StringEncoding)
                if let message = message {
                    print("Upload successful: \(message)")
                }
                self.saveCredentialsToUserDefaults()
                self.hideHUDAfterShowingMessage(NSLocalizedString("UploadSuccessMessage", comment: ""), isError:false)
            },
            failure: { operation, error in
                print("Upload failed: \(error.localizedDescription)")
                self.hideHUDAfterShowingMessage(NSLocalizedString("UploadFailedMessage", comment: ""), isError:true)
            }
        )
    }
    
    private func hideHUDAfterShowingMessage(message: String, isError: Bool) {
        let hud = MBProgressHUD.allHUDsForView(self.contentView)[0] as! MBProgressHUD
        hud.mode = .Text
        hud.labelText = message
        
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue()) {
            MBProgressHUD.hideHUDForView(self.contentView, animated: true)
            if !isError {
                self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    private func saveCredentialsToUserDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(teamNameTextField.text, forKey: kAppQuestTeamNameKey)
        defaults.setObject(teamCodeTextField.text, forKey: kAppQuestTeamCodeKey)
        defaults.synchronize()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let keyboardAnimationDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        let keyboardHeight = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size.height
        UIView.animateWithDuration(keyboardAnimationDuration) {
            self.scrollViewBottom.constant = keyboardHeight
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let keyboardAnimationDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        UIView.animateWithDuration(keyboardAnimationDuration) {
            self.scrollViewBottom.constant = 0
        }
    }
    
    @IBAction func dismissUploadViewController(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}