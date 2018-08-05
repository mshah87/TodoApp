//
//  Item.swift
//  TodoApp
//
//  Created by Maulik Shah on 2018-08-04.
//  Copyright © 2018 Maulik Shah. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var datecreated : Date?
    
    //inverse relationship (each item has parent category)
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
