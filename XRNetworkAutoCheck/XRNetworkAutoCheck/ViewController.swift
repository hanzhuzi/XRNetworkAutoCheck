//
//  ViewController.swift
//  XRNetworkAutoCheck
//
//  Created by 寒竹子 on 16/4/10.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        XRNetworkCheckTool.sharedTool()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

