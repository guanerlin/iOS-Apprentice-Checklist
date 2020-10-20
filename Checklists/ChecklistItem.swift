//
//  ChecklistItem.swift
//  Checklists
//
//  Created by zhenglin on 2020/10/14.
//  Copyright © 2020 zhenglin. All rights reserved.
//

import Foundation

class ChecklistItem : NSObject, Codable {
    var text = ""
    var checked = false
    
    func toogleChecked() {
        checked.toggle()
    }
}
