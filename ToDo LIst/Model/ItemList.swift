//
//  ItemList.swift
//  ToDo LIst
//
//  Created by fares elsokary on 9/25/18.
//  Copyright © 2018 fares elsokary. All rights reserved.
//

import Foundation
import RealmSwift
class ItemList : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
   
    let parentCaegory = LinkingObjects(fromType: Category.self, property: "items")
}
