//
//  DataModel.swift
//  Checklists
//
//  Created by zhenglin on 2020/10/16.
//  Copyright © 2020 zhenglin. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTimeLaunch()
    }
    // MARK:- Data Persistence
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklists() {
        print(dataFilePath())
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode([Checklist].self, from: data)
                sortChecklists()
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
    
    func sortChecklists() {
        lists.sort(by: {
            list1, list2 in
            return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        })
    }
    
    func registerDefaults() {
        let dictionary = ["ChecklistIndex":-1, "AppFirstTimeShow": true] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTimeLaunch() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "AppFirstTimeShow")
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "AppFirstTimeShow")
            userDefaults.synchronize()
        }
    }
}
