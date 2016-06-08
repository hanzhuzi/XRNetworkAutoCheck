# XRNetworkAutoCheck
###实时监测当前网络类型，可以检测2G，3G，4G，wifi，有网络或者没有网络连接。

###修改网络状态的监听方式，支持iPV6协议。

###Use
```
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

```
