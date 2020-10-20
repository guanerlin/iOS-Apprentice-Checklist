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
    var items = [ChecklistItem]()
    init(name: String) {
        self.name = name
        super.init()
    }
    
    func countUncheckedItem() -> Int {
//        var count = 0
//        for item in items where !item.checked {
//            count += 1
//        }
//        return count
        return items.reduce(0) {cnt, item in cnt + (item.checked ? 0 : 1)}
    }

}
