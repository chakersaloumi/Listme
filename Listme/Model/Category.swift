//
//  Category.swift
//  Listme
//
//  Created by Chaker on 11/9/18.
//  Copyright © 2018 Chaker Saloumi. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
