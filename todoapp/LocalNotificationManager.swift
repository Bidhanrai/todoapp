//
//  LocalNotificationManager.swift
//  todoapp
//
//  Created by Bidhan Rai on 06/01/2021.
//

import UIKit

class LocalNotificationManager {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    public func addNotifications(toDoItem: ToDoItem, indexValue: Int) {
        
        //configuring notification content
        let content = UNMutableNotificationContent()
        content.title = toDoItem.title
        content.body = "A long description of your notification"
        content.sound = UNNotificationSound.default

        content.userInfo = ["CustomData": "You will be able to include any kind of information here"]
        
        //specify the conditions for delivery
        
        //let yourDate = Calendar.current.date(byAdding: .second, value: 5, to: Date())!
        //let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: yourDate.timeIntervalSinceNow, repeats: false)
        
        let calender = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.calendar = calender
        dateComponents.weekday = calender.component(.weekday, from: toDoItem.date) // Tuesday
        dateComponents.hour = calender.component(.hour, from: toDoItem.date)
        dateComponents.minute = calender.component(.minute, from: toDoItem.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        

        //create and register a notification request
//        let uuidString = UUID().uuidString
        let request = UNNotificationRequest.init(identifier: String(indexValue), content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
           }
        }
    }
    
    public func removeNotification(identifier: [String]) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifier)
        print("removed the notificaiton")
        notificationCenter.removeAllDeliveredNotifications()
        //notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(requests.count)
                print(request)
                print("///////////")
            }
        })
    }
}
