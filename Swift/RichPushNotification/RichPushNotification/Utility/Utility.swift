//
//  Utility.swift
//  RichPushNotification
//
//  Created by William.Weng on 2022/6/5.
//

import UIKit


// MARK: - Utility (單例)
final class Utility: NSObject {
    static let shared = Utility()
    private override init() {}
}

// MARK: - UNUserNotificationCenterDelegate
extension Utility: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .alert])
    }
}

// MARK: - 推播相關 (AppDelegate)
extension Utility {

    /// [推播權限測試](https://www.jianshu.com/p/1320e74e3a7e)
    /// - 使用在登入後才詢問推播
    /// - Parameters:
    ///   - delegate: UNUserNotificationCenterDelegate
    ///   - grantedHandler: 答應的時候要做什麼？
    ///   - rejectedHandler: 沒答應 / 不答應的時候要做什麼？
    ///   - result: (UNAuthorizationStatus) -> Void
    func userNotificationSetting(delegate: UNUserNotificationCenterDelegate? = nil, grantedHandler: @escaping () -> Void, rejectedHandler: @escaping () -> Void, result: @escaping (UNAuthorizationStatus) -> Void) {

        let center = UNUserNotificationCenter.current()
        let authorizationOptions: UNAuthorizationOptions = [.alert, .badge, .sound]

        center.getNotificationSettings { (settings) in

            let authorizationStatus = settings.authorizationStatus
            
            switch (authorizationStatus) {
            case .notDetermined:
                center.requestAuthorization(options: authorizationOptions) { (isGranted, error) in
                    guard isGranted else { rejectedHandler(); return }
                    DispatchQueue.main.async { self.registerForRemoteNotifications() }
                    grantedHandler()
                }
            case .authorized:
                DispatchQueue.main.async { self.registerForRemoteNotifications() }
                center.delegate = delegate ?? self
            case .ephemeral:
                DispatchQueue.main.async { self.registerForRemoteNotifications() }
                center.delegate = delegate ?? self
            case .denied: print("denied")
            case .provisional: print("provisional")
            @unknown default: fatalError()
            }
            
            result(authorizationStatus)
        }
    }
    
    /// 註冊推播 => MainQueue
    func registerForRemoteNotifications() { UIApplication.shared.registerForRemoteNotifications() }
    
    /// 推播的授權狀態
    /// - Parameter result: (UNAuthorizationStatus) -> Void
    func pushNotificationAuthorization(result: @escaping (UNAuthorizationStatus) -> Void) {

        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            result(settings.authorizationStatus)
        }
    }
    
    /// 取得手機的PushToken之類的字串，Copy到剪貼簿上 + 震動提示
    func pasteMessage(_ message: String) {
                
        let feedBackGenertor = UINotificationFeedbackGenerator()
        let pasteboard = UIPasteboard.general
        
        pasteboard.string = message
        feedBackGenertor.notificationOccurred(.success)
    }
}
