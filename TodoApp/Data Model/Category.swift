//
//  Category.swift
//  TodoApp
//
//  Created by Maulik Shah on 2018-08-04.
//  Copyright © 2018 Maulik Shah. All rights reserved.
//

import Foundation
import RealmSwift

//category is realm object
class Category: Object {
    @objc dynamic var name : String = ""
    
    //forward relationship (one to many)
    //this is a property
    let items = List<Item>()
}
