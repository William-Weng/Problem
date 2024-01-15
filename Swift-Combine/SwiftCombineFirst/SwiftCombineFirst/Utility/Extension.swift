//
//  Extension.swift
//  Example
//
//  Created by William.Weng on 2023/9/11.
//

import UIKit
import Combine

extension UIDevice {
    
    /// [取得鍵盤相關資訊](https://medium.com/彼得潘的-swift-ios-app-開發教室/18-ios-鍵盤通知-監聽-d45bd97841a6)
    /// - UIResponder.keyboardDidShowNotification / UIResponder.keyboardDidHideNotification
    /// - Parameter notification: 鍵盤的notification
    /// - Returns: Constant.KeyboardInformation?
    static func _keyboardInformation(notification: Notification) -> Constant.KeyboardInformation? {
        
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
              let beginFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let isLocal = userInfo[UIResponder.keyboardIsLocalUserInfoKey] as? Bool
        else {
            return nil
        }
        
        return (isLocal: isLocal, duration: duration, curve: curve, beginFrame: beginFrame, endFrame: endFrame)
    }
}

// MARK: - Cancellable (function)
extension Cancellable {
    
    /// [取得被釋放掉的回應](https://shareup.app/blog/how-to-clean-up-resources-when-a-combine-publisher-is-cancelled/)
    /// => .onCancel { print("cancelled") }.store(in: &cancellables)
    /// - Parameter closure: () -> Void
    /// - Returns: AnyCancellable
    func onCancel(_ closure: @escaping () -> Void) -> AnyCancellable {
        AnyCancellable { self.cancel(); closure() }
    }
}
