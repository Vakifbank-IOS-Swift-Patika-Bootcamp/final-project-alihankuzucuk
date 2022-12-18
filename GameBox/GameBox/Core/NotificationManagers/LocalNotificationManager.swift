//
//  LocalNotificationManager.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 15.12.2022.
//

import UIKit
import UserNotifications

// MARK: - Protocols
// MARK: LocalNotificationManagerProtocol
protocol LocalNotificationManagerProtocol {
    
    func registerForRemoteNotification(completion: @escaping (Bool) -> Void)
    func scheduleLocalNotification(notificationTitle: String, notificationSubtitle: String, notificationBody: String)
    
}

// MARK: - LocalNotificationManager
final class LocalNotificationManager: LocalNotificationManagerProtocol {
    
    /// Request notification permission & register for notification
    func registerForRemoteNotification(completion: @escaping (Bool) -> Void) {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                    completion(true)
                }else{
                    completion(false)
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
            completion(true)
        }
    }
    
    /// Schedules UserNotification
    func scheduleLocalNotification(notificationTitle: String, notificationSubtitle: String, notificationBody: String) {
        // First create notification content
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = notificationTitle
        notificationContent.subtitle = notificationSubtitle
        notificationContent.body = notificationBody
        notificationContent.sound = UNNotificationSound.default
        
        // Show this notification duration from now (in seconds)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(10), repeats: false)
        
        // Use uniqueue identifier as identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    
}
