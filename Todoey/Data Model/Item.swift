//
//  Item.swift
//  Todoey
//
//  Created by Yinpeng Chen on 2018-06-10.
//  Copyright © 2018 Yinpeng Chen. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
