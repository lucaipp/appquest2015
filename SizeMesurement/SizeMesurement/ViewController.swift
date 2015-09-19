//
//  ViewController.swift
//  SizeMesurement
//
//  Created by Luca Ippolito on 19.09.15.
//  Copyright © 2015 Team BZT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var txtDistance: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var swMode: UISwitch!
    @IBOutlet weak var btnTakeMesurement: UIButton!
    @IBOutlet weak var btnLog: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swMode.setOn(false, animated: false)
        
        enableGuiElements(false)
        btnLog.enabled = false
    }
    
    func enableGuiElements(enabled: Bool) {
        txtHeight.enabled = enabled
        txtHeight.text = ""
        btnTakeMesurement.enabled = !enabled
        btnLog.enabled = false
    }
    
    @IBAction func changeGuiState(sender: AnyObject) {
        enableGuiElements(swMode.on)
    }
    
    @IBAction func textEdited(sender: AnyObject) {
        if(txtHeight.text!.isEmpty) {
            btnLog.enabled = false
        }
        else {
            btnLog.enabled = true
        }
    }
    
    @IBAction func mesurementStarted(sender: AnyObject) {
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
}

