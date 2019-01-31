//
//  GradientTableViewCell.swift
//  CoreDataDemo
//
//  Created by Alex wee on 2019/1/31.
//  Copyright © 2019年 Alex wee. All rights reserved.
//

import UIKit

class GradientTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        // Initialization code
    }
    
    override  open class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
    
 
    
    
    func addGradientColor(colors:[CGColor],locations:[NSNumber],stratPoint:CGPoint,endPoint:CGPoint) {
        
        (self.layer as!CAGradientLayer).startPoint = stratPoint
        (self.layer as!CAGradientLayer).endPoint = endPoint
        (self.layer as!CAGradientLayer).locations = locations
        (self.layer as!CAGradientLayer).colors = colors
        
    }
    
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
