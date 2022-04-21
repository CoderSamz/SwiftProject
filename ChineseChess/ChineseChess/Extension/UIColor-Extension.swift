//
//  UIColor-Extension.swift
//  HYComponents
//  
//  Created by CoderSamz on 2022.
// 	
// 
    

import UIKit

extension UIColor {
    
    class func randomColor() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256)) / 255.0, green: CGFloat(arc4random_uniform(256)) / 255.0, blue: CGFloat(arc4random_uniform(256)) / 255.0, alpha: 1.0)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    convenience init?(hexString: String) {
        guard hexString.count >= 6 else {
            return nil
        }
        
        var hexTempString = hexString.uppercased()
        
        if hexTempString.hasPrefix("0X") || hexString.hasPrefix("##") {
//            hexTempString = String(hexString[hexString.index(hexString.startIndex, offsetBy: 2)..<hexString.endIndex])
            hexTempString = (hexTempString as NSString).substring(from: 2)
        }
        
        if hexTempString.hasPrefix("#") {
            hexTempString = (hexTempString as NSString).substring(from: 1)
        }
        
        var range = NSRange(location: 0, length: 2)
        let rHex = (hexTempString as NSString).substring(with: range)
        range.location = 2
        let gHex = (hexTempString as NSString).substring(with: range)
        range.location = 4
        let bHex = (hexTempString as NSString).substring(with: range)
        
        var r : UInt64 = 0
        var g : UInt64 = 0
        var b : UInt64 = 0
        Scanner(string: rHex).scanHexInt64(&r)
        Scanner(string: gHex).scanHexInt64(&g)
        Scanner(string: bHex).scanHexInt64(&b)
        
        self.init(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b))
    }
}

// MARK: - 从颜色中获取RGB的值
extension UIColor {
    func getRGBValue() -> (CGFloat, CGFloat, CGFloat) {
        
//        guard let cmps = self.cgColor.components  else {
//            fatalError("重大错误！！!请确定改颜色是通过RGB创建的！！！!!")
//        }
//
//        if cmps.count < 3 {
//            fatalError("重大错误！！请确定改颜色是通过RGB创建的！！！")
//        }
//        return  (cmps[0] * 255, cmps[1] * 255, cmps[2] * 255)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        return (red * 255, green * 255, blue * 255)
    }
}
