//
//  Extension+.swift
//  RichPushNotification
//
//  Created by William.Weng on 2022/6/5.
//

import UIKit

// MARK: - AppDelegate (class function)
extension UIApplication {
    
    /// [取得由推播打開APP的userInfo](https://developerhowto.com/2018/12/07/implement-push-notifications-in-ios-with-swift/)
    /// [application(_:didFinishLaunchingWithOptions:)](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622921-application)
    /// - Parameter launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    /// - Returns: [AnyHashable : Any]?
    func remoteNotificationUserInfo(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> [AnyHashable : Any]? {
        
        guard let remoteNotification = launchOptions?[.remoteNotification],
              let userInfo = remoteNotification as? [AnyHashable : Any]
        else {
            return nil
        }
        
        return userInfo
    }
}

// MARK: - Data (class function)
extension Data {
    
    /// Data => 16進位文字
    /// - %02x - 推播Token常用
    /// - Returns: String
    func _hexString() -> String {
        let hexString = reduce("") { return $0 + String(format: "%02x", $1) }
        return hexString
    }
}
