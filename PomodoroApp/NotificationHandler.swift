//
//  NotificationHandler.swift
//  PomodoroApp
//
//  Created by Kotaro Suto on 2020/09/14.
//  Copyright © 2020 Kotaro Suto. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationHandler {
    static let shared = NotificationHandler()
    private let center = UNUserNotificationCenter.current()
    init() {
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                self.center.requestAuthorization(options: [.alert]) { (success, error) in
                    if !success {
                        print("Error : \(String(describing: error?.localizedDescription))")
                    }
                }
            }
        }
    }
    
    func requestLocalNotification(after: TimeInterval = 0) -> UNNotificationRequest {
        let now = Date()
        let requestTime = Calendar.current.date(byAdding: .second, value: Int(after), to: now)
        return requestLocalNotification(title: "時間になりました", message: "休憩です",
                                        month: Calendar.current.component(.month, from: requestTime!),
                                        day: Calendar.current.component(.day, from: requestTime!),
                                        hour: Calendar.current.component(.hour, from: requestTime!),
                                        minute: Calendar.current.component(.minute, from: requestTime!),
                                        second: Calendar.current.component(.second, from: requestTime!))
    }
    
    func requestLocalNotification(title:String = "", message:String, month: Int, day: Int,hour:Int = 9, minute:Int = 0, second:Int = 0 ) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = UNNotificationSound.default
        
        var notificationTime = DateComponents()
        notificationTime.month = month
        notificationTime.day = day
        notificationTime.hour = hour
        notificationTime.minute = minute
        notificationTime.second = second
        
        let trigger: UNNotificationTrigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
        
        let request = UNNotificationRequest(identifier: "Pomodoro", content: content, trigger: trigger)
        
        return request
    }
    
    func add(notificationRequest: UNNotificationRequest) {
        center.add(notificationRequest) { (error) in
            guard let err = error else { return }
            print("Error : \(err.localizedDescription) occured in \(#function)")
        }
    }
}
