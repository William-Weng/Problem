//
//  AppDelegate.swift
//  RichPushNotification
//
//  Created by William.Weng on 2022/6/5.
//
// macOS 12.4 M1 / Xcode 13.4.1

import UIKit
import WWPrint

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let CategoryId: String = "MyCategory"
    
    var window: UIWindow?
    var pushToken: String?
    var userInfo: [AnyHashable: Any]?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initSetting(application, launchOptions: launchOptions)
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        pushToken = deviceToken._hexString()
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        self.userInfo = notification.request.content.userInfo
        completionHandler([.badge, .sound, .alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.userInfo = response.notification.request.content.userInfo
        completionHandler()
    }
}

// MARK: - 推播相關
extension AppDelegate {
    
    /// https://www.jianshu.com/p/26b96b991eaf
    /// [初始化設定](https://onevcat.com/2016/08/notification/)
    /// - Parameters:
    ///   - application: [UIApplication](https://www.avanderlee.com/swift/rich-notifications/)
    ///   - launchOptions: [[UIApplication.LaunchOptionsKey: Any]?](https://doc.batch.com/ios/sdk-integration/rich-notifications-setup)
    func initSetting(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        Utility.shared.userNotificationSetting(delegate: self) {
            wwPrint("Granted")
        } rejectedHandler: {
            wwPrint("Reject")
        } result: { (status) in
            wwPrint(status.rawValue)
        }
        
        self.userInfo = application.remoteNotificationUserInfo(launchOptions: launchOptions)
        self.notificationCategorySetting(identifier: CategoryId)
    }
    
    /// [註冊Notification Content Extension => Category](https://www.appcoda.com.tw/user-notifications-ios12/)
    /// - Parameter identifier: [String](https://www.appcoda.com.tw/push-notification/)
    func notificationCategorySetting(identifier: String) {
        let category = UNNotificationCategory(identifier: identifier, actions: [], intentIdentifiers: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
}
