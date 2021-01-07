//
//  ToDoItem.swift
//  todoapp
//
//  Created by Bidhan Rai on 04/01/2021.
//

import UIKit
import os.log

class ToDoItem: NSObject, NSCoding {
    
    var title: String
    var date: Date
    var active: Bool
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURl = DocumentsDirectory.appendingPathComponent("todoitems")
    
    //MARK: Types
    struct PropertyKey {
        static let title = "title"
        static let dateTime = "dateTime"
        static let active = "active"
    }
    
    init?(title: String, date: Date, active: Bool) {
        
        if title.isEmpty {
            return nil
        }
        
        //Initialize stored properties
        self.title = title
        self.date = date
        self.active = active
    }
    
    //MARK: NSCoding
    
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: PropertyKey.title)
        coder.encode(date, forKey: PropertyKey.dateTime)
        coder.encode(active, forKey: PropertyKey.active)
    }
    
    required convenience init?(coder: NSCoder) {
        guard let title = coder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the title for a ToDoItem object.", log: OSLog.default, type: .debug)
               return nil
        }
        
        guard let dateTime = coder.decodeObject(forKey: PropertyKey.dateTime) as? Date else {
            os_log("Unable to decode the dateTime for a ToDoItem object.", log: OSLog.default, type: .debug)
               return nil
        }
        
        guard let active = coder.decodeObject(forKey: PropertyKey.active) as? Bool else {
            os_log("Unable to decode the active for a ToDoItem object.", log: OSLog.default, type: .debug)
               return nil
        }
        
        //must call designated initializer
        self.init(title: title, date: dateTime, active: active)
    }
}

