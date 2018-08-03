//
//  Item.swift
//  TodoApp
//
//  Created by Maulik Shah on 2018-08-01.
//  Copyright © 2018 Maulik Shah. All rights reserved.
//

import Foundation

//item type is now able to encode itself into plist or json
//codable means encodable and decodable
class Item: Codable {

    var title : String = ""
    var done : Bool = false
}
