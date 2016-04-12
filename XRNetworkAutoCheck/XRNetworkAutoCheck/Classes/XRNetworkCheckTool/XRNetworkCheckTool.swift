//
//  XRNetworkCheckTool.swift
//  XRNetworkAutoCheck
//
//  Created by 寒竹子 on 16/4/10.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

/**
 *  @brief 网络状态和网络类型监测
 *         监测网络类型： WiFi, 2G, 3G, 4G
 *         监测网络状态： 有网，无网
 *
 *  @by    黯丶野火
 **/

import UIKit
import CoreTelephony

// 网络类型定义
enum XRNetworkType {
    
    case XRNet_NUKnow
    case XRNet_UNEnable
    case XRNet_2G
    case XRNet_3G
    case XRNet_4G
    case XRNet_WiFi
}

@objc(XRNetworkCheckTool)
class XRNetworkCheckTool: NSObject {
    
    var netCheckClosure: ((networkType: XRNetworkType) -> ())?
    var googleReach: Reachability?
    var internetReach: Reachability?
    var currentNetStatus: XRNetworkType = .XRNet_UNEnable
    var preNetStatus: XRNetworkType = .XRNet_NUKnow
    
    let hostName: String = {
        return "www.google.com"
    }()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override init() {
        super.init()
        
        self.googleReach = Reachability(hostName: hostName)
        self.googleReach?.reachableBlock = { reachability -> () in
            self.reachabilityCallBack(reachability)
        }
        self.googleReach?.unreachableBlock = { reachability -> () in
            self.reachabilityCallBack(reachability)
        }
        self.googleReach?.startNotifier()
        
        self.internetReach = Reachability.reachabilityForInternetConnection()
        self.internetReach?.reachableBlock = { reachability -> () in
            self.reachabilityCallBack(reachability)
        }
        
        self.internetReach?.unreachableBlock = { reachability -> () in
            self.reachabilityCallBack(reachability)
        }
        
        self.internetReach?.startNotifier()
    }
    
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
    
    func getNetworkType() -> XRNetworkType {
        
        // 每次检测都必须创建一个对象，否则锁屏后将无法获取网络信息
        let telephonyNetInfo = CTTelephonyNetworkInfo()
        let netStatus = telephonyNetInfo.currentRadioAccessTechnology
        var networkType: XRNetworkType = .XRNet_NUKnow
        
        if let currentRadioTech = netStatus {
            
            switch currentRadioTech {
                
            case CTRadioAccessTechnologyGPRS:
                networkType = .XRNet_2G
            case CTRadioAccessTechnologyEdge:
                networkType = .XRNet_2G
            case CTRadioAccessTechnologyeHRPD:
                networkType = .XRNet_3G
            case CTRadioAccessTechnologyHSDPA:
                networkType = .XRNet_3G
            case CTRadioAccessTechnologyCDMA1x:
                networkType = .XRNet_2G
            case CTRadioAccessTechnologyLTE:
                networkType = .XRNet_4G
            case CTRadioAccessTechnologyCDMAEVDORev0:
                networkType = .XRNet_3G
            case CTRadioAccessTechnologyCDMAEVDORevA:
                networkType = .XRNet_3G
            case CTRadioAccessTechnologyCDMAEVDORevB:
                networkType = .XRNet_3G
            case CTRadioAccessTechnologyHSUPA:
                networkType = .XRNet_3G
            default:
                break
            }
        }
        
        return networkType
    }
    
    func reachabilityCallBack(myReach: Reachability?) {
        
        var networkType: XRNetworkType = .XRNet_NUKnow
        
        if let reach = myReach {
            
            if reach.isReachable() {
                if reach.isReachableViaWiFi() {
                    networkType = .XRNet_WiFi
                }else if reach.isReachableViaWWAN() {
                    networkType = getNetworkType()
                }
            }else {
                networkType = .XRNet_UNEnable
            }
        }
        
        self.currentNetStatus = networkType
        
        if currentNetStatus != preNetStatus {
            preNetStatus = currentNetStatus
            if let closure = netCheckClosure {
                closure(networkType: currentNetStatus)
            }
        }
        
    }
    
    func getNetworkTypeWithClosure(closure: ((networkType: XRNetworkType) -> ())?) -> () {
        self.netCheckClosure = closure
    }
}


