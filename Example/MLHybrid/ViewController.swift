//
//  ViewController.swift
//  MLHybrid
//
//  Created by yang cai on 08/08/2017.
//  Copyright (c) 2017 yang cai. All rights reserved.
//

import UIKit
import MLHybrid

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func click(_ sender: Any) {
//        let dddd = MLHybrid.load(urlString: "http://web.qa.medlinker.com/h5/hospital/z_index.html?serviceType=1&type=d")
        let dddd = MLHybrid.load(urlString: "http://web.qa.medlinker.com/h5/hospital/z_home.html")

        let navi = UINavigationController(rootViewController: dddd!)
        navi.navigationBar.isTranslucent = false
        self.present(navi, animated: true, completion: nil)
        
    }

}

