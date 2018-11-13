//
//  Item.swift
//  Listme
//
//  Created by Chaker on 11/9/18.
//  Copyright © 2018 Chaker Saloumi. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory  = LinkingObjects(fromType: Category.self, property: "items")
    @objc dynamic var date: Date?
    
}
