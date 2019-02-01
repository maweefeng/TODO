//
//  Item.swift
//  CoreDataDemo
//
//  Created by Alex wee on 2019/2/1.
//  Copyright © 2019年 Alex wee. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {

    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?

    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    
}
