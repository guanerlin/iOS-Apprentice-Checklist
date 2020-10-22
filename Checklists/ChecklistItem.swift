//
//  ChecklistItem.swift
//  Checklists
//
//  Created by zhenglin on 2020/10/14.
//  Copyright © 2020 zhenglin. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem : NSObject, Codable {
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    
    override init() {
        super.init()
        itemID = DataModel.nextChecklistItemID()
    }
    
    func toogleChecked() {
        checked.toggle()
    }
    
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
        	let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = .default
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: String(itemID), content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request)
            print("Scheduled: \(request) for itemID: \(itemID)")
        } 
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [String(itemID)])
    }
}
