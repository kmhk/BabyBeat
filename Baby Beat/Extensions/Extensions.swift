//
//  Extensions.swift
//  AWF
//
//  Created by OSX on 02/12/15.
//  Copyright © 2015 Manish Gumbal. All rights reserved.
//

import Foundation
import UIKit

var userdefaults=NSUserDefaults.standardUserDefaults()
var currentScreen=String()



extension UIButton
{
    public func setCornerRadiusButton(radius: CGFloat)
    {
        self.layer.cornerRadius=radius
        self.layer.masksToBounds=true
    }
    
    public func setShadow(radius: CGFloat, opacity: Float, size: CGSize)
    {
        self.layer.masksToBounds=false
        self.layer.shadowColor=UIColor.blackColor().CGColor
        self.layer.shadowOpacity=opacity
        self.layer.shadowRadius=radius
        self.layer.shadowOffset=size
    }
    
    public func setBorderButton(color:UIColor, width:CGFloat)
    {
        self.layer.borderColor=color.CGColor
        self.layer.borderWidth=width
        self.layer.masksToBounds=true
    }
}

extension UIView
{
    public func setCornerRadiusView(radius: CGFloat)
    {
        self.layer.cornerRadius=radius
        self.layer.masksToBounds=true
    }
    
    public func setShadowView(radius: CGFloat, opacity: Float, size: CGSize)
    {
        self.layer.masksToBounds=false
        self.layer.shadowColor=UIColor.blackColor().CGColor
        self.layer.shadowOpacity=opacity
        self.layer.shadowRadius=radius
        self.layer.shadowOffset=size
    }

    
    public func setBorderView(color:UIColor, width:CGFloat)
    {
        self.layer.borderColor=color.CGColor
        self.layer.borderWidth=width
        self.layer.masksToBounds=true
    }
    
    public func setGradient(color1: UIColor, color2:UIColor, loc1: CGFloat, loc2:CGFloat)
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        let color1 = color1.CGColor as CGColorRef
        let color2 = color2.CGColor as CGColorRef
        gradientLayer.colors = [color2,color2,color1,color1]
        gradientLayer.locations = [0.0,0.5,0.8,1.0]
        //gradientLayer.position = CGPointMake(0, 0)
        //self.layer.addSublayer(gradientLayer)
        self.layer.insertSublayer(gradientLayer,atIndex: 0)
    }
}

extension UIImageView
{
    public func setBackground()
    {
        if(userdefaults.valueForKey("background")==nil || userdefaults.valueForKey("background") as! String=="turqoise")
        {
            self.image=UIImage(named: "greenBackground")
        }
        else if(userdefaults.valueForKey("background") as! String=="blue")
        {
            self.image=UIImage(named: "blueBackground")
        }
        else if(userdefaults.valueForKey("background") as! String=="pink")
        {
            self.image=UIImage(named: "pinkBackground")
        }
        else
        {
            self.image=UIImage(named: "greenBackground")
        }
    }
}
extension UIImageView
{
    public func setOverlay()
    {
        if(userdefaults.valueForKey("background")==nil || userdefaults.valueForKey("background") as! String=="turqoise")
        {
            self.image=UIImage(named: "greenOverlay")
        }
        else if(userdefaults.valueForKey("background") as! String=="blue")
        {
            self.image=UIImage(named: "blueOverlay")
        }
        else if(userdefaults.valueForKey("background") as! String=="pink")
        {
            self.image=UIImage(named: "pinkOverlay")
        }
        else
        {
            self.image=UIImage(named: "greenOverlay")
        }
    }
}


public extension UIDevice
{
    
   @objc var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPhone"
        case "iPod7,1":                                 return "iPhone"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone"
        case "iPhone4,1":                               return "iPhone"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone"
        case "iPhone7,2":                               return "iPhone"
        case "iPhone7,1":                               return "iPhone+"
        case "iPhone8,1":                               return "iPhone"
        case "iPhone8,2":                               return "iPhone+"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad"
        case "iPad5,3", "iPad5,4":                      return "iPad"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad"
        case "iPad5,1", "iPad5,2":                      return "iPad"
        case "iPad6,7", "iPad6,8":                      return "iPad"
        case "i386", "x86_64":                          return "iPad"
        default:                                        return identifier
        }
    }
    
}

public extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.sharedApplication()
        for url in urls {
            if application.canOpenURL(NSURL(string: url)!) {
                application.openURL(NSURL(string: url)!)
                return
            }
        }
    }
}
