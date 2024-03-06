//
//  AppDelegate.swift
//  cupOfPositivity
//
//  Created by Vanessa Johnson on 3/2/24.
//

import UIKit
import UserNotifications
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        // Schedule initial notification
        scheduleDailyNotification()
        return true
    }

    func scheduleDailyNotification(withItems items: [Quote]) {
        // Calculate the next valid date for scheduling the notification
        var dateComponents = DateComponents()
        dateComponents.hour = 23
        dateComponents.minute = 8
        var nextValidDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) // Schedule for tomorrow
        if let nextValidDate = nextValidDate {
            nextValidDate = Calendar.current.date(bySettingHour: dateComponents.hour ?? 0, minute: dateComponents.minute ?? 0, second: 0, of: nextValidDate) ?? 0
        }
        
        // Create notification content
        let randomInt = Int(arc4random_uniform(UInt32(items.count)))
        let content = UNMutableNotificationContent()
        content.title = "A Little Bit of Positivity"
        content.body = "\(items[Int(randomInt)].quote ?? "I hope you have an amazing day!")"
        
        // Create notification trigger with the calculated next valid date
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: nextValidDate ?? Date()), repeats: true)
        
        // Create notification request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        // Remove any existing pending notification requests
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
        
        // Request authorization and schedule the notification
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        notificationCenter.requestAuthorization(options: options) { success, error in
            DispatchQueue.main.async {
                if success {
                    notificationCenter.add(request)
                }
            }
        }
    }


    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Schedule a new notification when the user interacts with or dismisses the previous notification
        scheduleDailyNotification()
        completionHandler()
    }
}
