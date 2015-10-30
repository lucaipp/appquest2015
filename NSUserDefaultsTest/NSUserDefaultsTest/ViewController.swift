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
    var indexarray = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func Save(sender: AnyObject) {
        
<<<<<<< Updated upstream
        for var index = 0; index < 10; ++index{
        let latitude = "31.231"
        let longitude = "82.4329"
        var codes = [[String]]()
        var loc = [String]()
        loc.append(index)
        codes.append(loc)
        var lat = [String]()
        lat.append(latitude)
        codes.append(lat)
        var long = [String]()
        long.append(longitude)
        codes.append(long)
        print(codes)
=======
        let latitude = 31.231
        let longitude = 82.4325
        for var indexfor = 0; indexfor < 1; ++indexfor
        {
            indexarray = indexarray + 1
            var codes = [[String]]()
            var index = [String]()
            index.append(String(indexarray))
            var lat = [String]()
            lat.append(String(latitude))
            var long = [String]()
            long.append(String(longitude))
            codes.append(index)
            codes.append(lat)
            codes.append(long)
            print(codes)
        }
>>>>>>> Stashed changes
        
        
    }

}

