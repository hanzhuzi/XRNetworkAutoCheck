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

        XRNetworkCheckTool.sharedTool().getNetworkTypeWithClosure { (networkType) in
            var netStatusTemp = "未知网络"
            
            switch networkType {
                
            case .XRNet_UNEnable:
                netStatusTemp = "网络已断开，请检查您的网络"
            case .XRNet_2G:
                netStatusTemp = "已切换到2G网络"
            case .XRNet_3G:
                netStatusTemp = "已切换到3G网络"
            case .XRNet_4G:
                netStatusTemp = "已切换到4G网络"
            case .XRNet_WiFi:
                netStatusTemp = "已切换到WiFi网络"
            case .XRNet_NUKnow:
                break
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                UIApplication.sharedApplication().keyWindow?.showHUD(netStatusTemp)
            })
        }
        
        XRNetworkCheckTool.sharedTool()
        XRNetworkCheckTool.sharedTool()
        XRNetworkCheckTool.sharedTool()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

