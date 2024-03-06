//
//  AppDelegate.swift
//  cupOfPositivity
//
//  Created by Vanessa Johnson on 3/2/24.
//

import Foundation

import UIKit
import SwiftUI
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the notification tap action here
        let userInfo = response.notification.request.content.userInfo
        
        // Assuming the identifier is a string that corresponds to a specific screen
        if let screenIdentifier = userInfo["screenIdentifier"] as? String {
            // Post a notification to navigate to the specific screen
            NotificationCenter.default.post(name: NSNotification.Name("Notifications"), object: screenIdentifier)
        }
        
        completionHandler()
    }
}
