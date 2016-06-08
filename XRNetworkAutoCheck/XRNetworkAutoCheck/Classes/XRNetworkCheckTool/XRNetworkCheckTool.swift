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
 *         支持iPv6
 *
 *  @by    黯丶野火
 */

import UIKit
import CoreTelephony

// 网络类型定义
enum XRNetworkType: Int {
    case XRNet_NUKnow
    case XRNet_UNEnable
    case XRNet_2G
    case XRNet_3G
    case XRNet_4G
    case XRNet_WiFi
}

typealias netChangedClosure = ((networkType: XRNetworkType) -> Void)

class XRNetworkCheckTool: NSObject {
    
    var netCheckClosure: netChangedClosure? // XRNetworkType 无法转成objc类型
    @objc(googleReach)
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "netStatusChanged:", name: kReachabilityChangedNotification, object: nil)
        self.googleReach = Reachability(hostName: hostName)
        self.googleReach?.startNotifier()
        
        self.internetReach = Reachability.reachabilityForInternetConnection()
        self.internetReach?.startNotifier()
    }
    
    struct Inner {
        static var tool: XRNetworkCheckTool?
        static var onceToken: dispatch_once_t = 0
    }
    
    static func sharedTool() -> XRNetworkCheckTool {
        
        dispatch_once(&Inner.onceToken) {
            if nil == Inner.tool {
                Inner.tool = XRNetworkCheckTool()
            }
        }
        
        return Inner.tool!
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
    
    // 监听到网络状态变化
    func netStatusChanged(notif: NSNotification) {
        
        let reach = notif.object as? Reachability
        var networkType: XRNetworkType = .XRNet_NUKnow
        
        if let reacha = reach {
            
            if reacha.currentReachabilityStatus() == NotReachable {
                networkType = .XRNet_UNEnable
            }else {
                if reacha.currentReachabilityStatus() == ReachableViaWiFi {
                    networkType = .XRNet_WiFi
                }else if reacha.currentReachabilityStatus() == ReachableViaWWAN {
                    networkType = getNetworkType()
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
    }
    
    func getNetworkTypeWithClosure(closure: netChangedClosure?) -> () {
        self.netCheckClosure = closure
    }
    
    
}


