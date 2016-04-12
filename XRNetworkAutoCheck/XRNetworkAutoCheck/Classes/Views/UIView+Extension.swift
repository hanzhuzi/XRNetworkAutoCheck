//
//  UIView+Extension.swift
//  XRNetworkAutoCheck
//
//  Created by xuran on 16/4/12.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

import Foundation

var HUDKey: Int = 10

@IBDesignable
extension UIView {
    
    var width: CGFloat {
        
        get {
            return self.bounds.width
        }
        
        set(newWidth) {
            self.bounds.size.width = newWidth
        }
    }
    
    var height: CGFloat {
        
        get {
            return self.bounds.height
        }
        
        set(newHeight) {
            self.bounds.size.height = newHeight
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        
        get {
            return layer.cornerRadius
        }
        
        set(newRadius) {
            self.layer.cornerRadius = newRadius
            self.layer.masksToBounds = newRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        
        get {
            return self.layer.borderWidth
        }
        
        set {
           self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        
        get {
            return UIColor(CGColor: layer.borderColor!)
        }
        
        set {
            layer.borderColor = newValue.CGColor
        }
    }
    
    var HUD: MBProgressHUD? {
        
        get {
            return objc_getAssociatedObject(self, &HUDKey) as? MBProgressHUD
        }
        
        set {
            objc_setAssociatedObject(self, &HUDKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showHUD(message: String?) {
        
        HUD = MBProgressHUD.showHUDAddedTo(self, animated: true)
        HUD?.mode = .Text
        HUD?.labelText = message
        
       let time = dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC)))
        
        dispatch_after(time, dispatch_get_main_queue()) {
            MBProgressHUD.hideHUDForView(self, animated: true)
        }
    }
    
    func hideHUD() {
        
    }
}