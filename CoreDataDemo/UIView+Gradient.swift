//
//  UIView+Gradient.swift
//  CoreDataDemo
//
//  Created by Alex wee on 2019/1/30.
//  Copyright © 2019年 Alex wee. All rights reserved.
//
import Foundation
import UIKit

extension CAGradientLayer {
    //获取彩虹渐变层
    
    func rainbowLayer() -> CAGradientLayer {
        //定义渐变的颜色（7种彩虹色）
        let gradientColors = [UIColor.red.cgColor,UIColor.orange.cgColor,UIColor.yellow.cgColor,UIColor.green.cgColor,UIColor.cyan.cgColor,UIColor.blue.cgColor,UIColor.purple.cgColor]
        //定义每种颜色所在的位置
        let gradientLocations:[NSNumber] = [0.0, 0.17, 0.33, 0.5, 0.67, 0.83, 1.0]
        //创建CAGradientLayer对象并设置参数
        self.colors = gradientColors
        self.locations = gradientLocations
        //设置渲染的起始结束位置（横向渐变）
        self.startPoint = CGPoint(x: 0, y: 0)
        self.endPoint = CGPoint(x: 1, y: 0)
        return self
    }
}

extension UIView{
    
    
    
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var rect = self.frame
            rect.origin.x = newValue
            self.frame = rect
        }
    }
    
    // .y
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var rect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
    }
    
    // .maxX
    public var maxX: CGFloat {
        get {
            return self.frame.maxX
        }
    }
    
    // .maxY
    public var maxY: CGFloat {
        get {
            return self.frame.maxY
        }
    }
    
    // .centerX
    public var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    
    // .centerY
    public var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    // .width
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var rect = self.frame
            rect.size.width = newValue
            self.frame = rect
        }
    }
    
    // .height
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var rect = self.frame
            rect.size.height = newValue
            self.frame = rect
        }
    }
    
    var startPoint : CGPoint{
        
        get{
            return self.startPoint
        }
        set{
            
        }
    }
    
    var endPoint : CGPoint{
        
        get{
            return self.endPoint
        }
        set{
            
        }
    }
    
    var colors :[CGColor]{
        get{
            return self.colors
        }
        set{
            
        }
        
    }
    
    var locations :[NSNumber]{
        get{
            return self.locations
        }
        set{
            
        }
        
    }
    
    
    
    
    private struct theAnswer {
        static var colors = [CGColor]()
    }
    var name: String {
        get {
            guard let theName = objc_getAssociatedObject(self, &theAnswer.colors) as? String else {
                return ""
            }
            return theName
        }
        set {
            objc_setAssociatedObject(self, &theAnswer.colors, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
//    open class var layerClass: Swift.AnyClass {
//        
//        
//            
//            return CAGradientLayer.self
//        
//        
//    }
    
    

 
    
//    func gradientViewWithColors(colors:[CGColor],locations:[NSNumber],stratPoint:CGPoint,endPoint:CGPoint) -> UIView {
//        let view = self
//        view.addGradientColor(colors: colors, locations: locations, stratPoint: stratPoint, endPoint: endPoint)
//        return view
//
//
//    }
    
//    func addGradientColor(colors:[CGColor],locations:[NSNumber],stratPoint:CGPoint,endPoint:CGPoint) {
//        
//        self.startPoint = stratPoint
//        self.endPoint = endPoint
//        self.locations = locations
//        self.colors = colors
//        
//    }
    
    
    
}
