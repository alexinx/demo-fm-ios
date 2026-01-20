//
//  ViewController.swift
//  DemoSDK
//
//  Created by 24449613 on 01/20/2026.
//  Copyright (c) 2026 24449613. All rights reserved.
//

import UIKit
import DemoSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let sdk = DemoSDK()
        sdk.start()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

