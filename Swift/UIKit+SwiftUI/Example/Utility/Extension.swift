//
//  Extension.swift
//  Example
//
//  Created by William.Weng on 2024/7/1.
//

import SwiftUI

// MARK: - UIView
extension UIView {
    
    /// [設定LayoutConstraint => 不能加frame](https://zonble.gitbooks.io/kkbox-ios-dev/content/autolayout/intrinsic_content_size.html)
    /// - Parameter view: [要設定的View](https://www.appcoda.com.tw/auto-layout-programmatically/)
    func _autolayout(on view: UIView) {

        removeFromSuperview()
        view.addSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

// MARK: - UIViewController
extension UIViewController {
    
    /// [使用SwiftUI所產生的View => shouldPerformSegue(withIdentifier:sender:)](https://sarunw.com/posts/swiftui-view-as-uiview/#turn-swiftui-view-into-uiviewcontroller)
    /// - Parameter rootView: [T: View](https://sarunw.com/posts/swiftui-view-as-uiviewcontroller-in-storyboard/)
    /// - Returns: [Bool](https://sarunw.com/posts/swiftui-view-as-uiview-in-storyboard/)
    func _swiftUIView<T: View>(rootView: T) -> Bool {
        
        guard let viewController = Optional.some(UIHostingController(rootView: rootView)),
              let swiftUIView = viewController.view
        else {
            return false
        }
        
        swiftUIView._autolayout(on: view)
        viewController.didMove(toParent: self)
        
        return true
    }
}
