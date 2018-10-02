//
//  Category.swift
//  ToDo LIst
//
//  Created by fares elsokary on 9/30/18.
//  Copyright © 2018 fares elsokary. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<ItemList>()
}
