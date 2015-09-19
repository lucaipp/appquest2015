//
//  ViewController.swift
//  SizeMesurement
//
//  Created by Luca Ippolito on 19.09.15.
//  Copyright © 2015 Team BZT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
//    @IBOutlet weak var txtDistance: UITextField!
//    @IBOutlet weak var txtHeight: UITextField!
//    @IBOutlet weak var swMode: UISwitch!
//    @IBOutlet weak var btnTakeMesurement: UIButton!
//    @IBOutlet weak var btnLog: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        swMode.setOn(false, animated: false)
        
        enableGuiElements(false)
//        btnLog.enabled = false
    }
    
    func enableGuiElements(enabled: Bool) {
//        txtHeight.enabled = enabled
//        btnTakeMesurement.enabled = enabled
    }
    
    @IBAction func changeGuiState(sender: AnyObject) {
//        enableGuiElements(swMode.on)
    }
}

