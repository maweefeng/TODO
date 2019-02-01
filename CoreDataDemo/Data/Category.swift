//
//  Category.swift
//  CoreDataDemo
//
//  Created by Alex wee on 2019/2/1.
//  Copyright © 2019年 Alex wee. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    
    @objc dynamic var name : String = ""
    
    let items = List<Item>()
}
