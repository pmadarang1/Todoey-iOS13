//
//  Category.swift
//  Todoey
//
//  Created by Phil Madarang on 11/22/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    
    //create relationships similar to CoreData for Category and Item
    
    //defines forward relationship...need to go to Item file to define inverse relationship
    let items = List<Item>() //create empty array/list of Item...similar to let array : [Int] = [1,2,3] or array = [Int]()
}
