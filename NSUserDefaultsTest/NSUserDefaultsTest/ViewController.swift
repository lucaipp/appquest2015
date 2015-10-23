//
//  ViewController.swift
//  NSUserDefaultsTest
//
//  Created by Jeffrey Jud on 23.10.15.
//  Copyright © 2015 Team BZT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func Save(sender: AnyObject) {
        
        let location = "Taegerwilen"
        let latitude = 31.231
        let longitude = 82.4325
        let codes = [[Double]]()
        var lat = [Double]()
        lat.append(latitude)
        var long = [Double]()
        long.append(longitude)
        print(codes)
        
        let dict = ["Name": location, "Lattiude": latitude, "Longitude": longitude]
        defaults.setObject(dict, forKey: "SavedDict")
        print(dict)
        
    }

}

