//
//  colorHex.swift
//  CoreDataDemo
//
//  Created by Alex wee on 2019/1/31.
//  Copyright © 2019年 Alex wee. All rights reserved.
//

import Foundation
import UIKit
//扩展部分
extension UIColor {
    // 16进制 转 RGBA
    class func rgbaColorFromHex(rgb:Int, alpha: CGFloat) ->UIColor {
        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: alpha)
    }
    
    //16进制 转 RGB
    class func rgbColorFromHex(rgb:Int) -> UIColor {
        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: 1.0)
    }
}
