//
//  XRNetworkCheckTool.swift
//  XRNetworkAutoCheck
//
//  Created by 寒竹子 on 16/4/10.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

/**
 *  网络状态和网络类型监测
 *  监测网络类型： WiFi, 2G, 3G, 4G
 *  监测网络状态： 有网，无网
 *  by 黯丶野火
 **/

import UIKit

// 网络类型定义
enum XRNetworkType {
    
    case XRNet_NUKnow
    case XRNet_UNEnable
    case XRNet_2G
    case XRNet_3G
    case XRNet_4G
    case XRNet_WiFi
}

class XRNetworkCheckTool: NSObject {
    
    var networkType: XRNetworkType = .XRNet_NUKnow
    var netCheckClosure: ((networkType: XRNetworkType) -> ())?
    
    static func sharedTool() -> XRNetworkCheckTool {
        
        var tool: XRNetworkCheckTool?
        var onceToken: dispatch_once_t = 0
        
        dispatch_once(&onceToken) {
            if nil == tool {
                tool = XRNetworkCheckTool()
            }
        }
        
        return tool!
    }
    
    
    
    func getNetworkTypeWithClosure(closure: ((networkType: XRNetworkType) -> ())?) -> () {
        self.netCheckClosure = closure
    }
}
