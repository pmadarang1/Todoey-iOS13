//
//  Item.swift
//  Todoey
//
//  Created by Phil Madarang on 11/1/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

class Item: Codable { //replaces Encodable, Decodable
    
    var title: String = ""
    var done: Bool = false
}
