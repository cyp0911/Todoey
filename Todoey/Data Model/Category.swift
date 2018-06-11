//
//  Category.swift
//  Todoey
//
//  Created by Yinpeng Chen on 2018-06-10.
//  Copyright © 2018 Yinpeng Chen. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
