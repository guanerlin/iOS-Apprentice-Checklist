//
//  Checklist.swift
//  Checklists
//
//  Created by zhenglin on 2020/10/16.
//  Copyright © 2020 zhenglin. All rights reserved.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var iconName = "No Icon"
    var items = [ChecklistItem]()
    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func countUncheckedItem() -> Int {
        return items.reduce(0) {cnt, item in cnt + (item.checked ? 0 : 1)}
    }
    
    

}
