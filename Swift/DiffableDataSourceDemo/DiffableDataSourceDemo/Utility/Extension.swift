//
//  Extension.swift
//  Example
//
//  Created by William.Weng on 2024/1/1.
//

import UIKit

// MARK: - Collection (override class function)
extension Collection {

    /// [為Array加上安全取值特性 => nil](https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings)
    subscript(safe index: Index) -> Element? { return indices.contains(index) ? self[index] : nil }
}

// MARK: - UITableViewCell (function)
extension UITableViewCell {
    
    /// [設定內建樣式 - iOS 14](https://apppeterpan.medium.com/從-ios-15-開始-使用內建-cell-樣式建議搭配-uilistcontentconfiguration-13d64eb317be)
    /// - Parameters:
    ///   - text: [主要文字](https://zhuanlan.zhihu.com/p/572526799)
    ///   - secondaryText: [次要文字](https://www.jianshu.com/p/e8843595a794)
    ///   - image: [圖示](https://medium.com/@dragos.rotaru9/uitableviewcell-in-ios-14-ef19e877319f)
    func _contentConfiguration(text: String?, secondaryText: String?, image: UIImage?) {
        
        var config = defaultContentConfiguration()
        
        config.text = text
        config.secondaryText = secondaryText
        config.image = image
        
        contentConfiguration = config
    }
}

// MARK: - UISwipeActionsConfiguration (static function)
extension UISwipeActionsConfiguration {
    
    /// [滑動按鈕設定](https://anny86023.medium.com/uitableview-swipe-action-客製化滑動按鈕動作-7b9e90155815)
    /// - Parameters:
    ///   - actions: [UIContextualAction]
    ///   - performsFirstActionWithFullSwipe: 防止cell滑到底之後，不小心觸發第一個按鈕
    static func _build(actions: [UIContextualAction], performsFirstActionWithFullSwipe: Bool = false) -> UISwipeActionsConfiguration {
        
        let configuration = UISwipeActionsConfiguration(actions: actions)
        configuration.performsFirstActionWithFullSwipe = performsFirstActionWithFullSwipe
        
        return configuration
    }
}

// MARK: - UICollectionView (static function)
extension UIContextualAction {
    
    /// [產生TableView滑動按鈕](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/客製表格-table-的-swipe-action-bed0a8bf7979)
    /// - tableView(_:leadingSwipeActionsConfigurationForRowAt:) / tableView(_:trailingSwipeActionsConfigurationForRowAt:)
    /// - Parameters:
    ///   - title: 標題
    ///   - style: 格式
    ///   - color: 底色
    ///   - image: 背景圖
    ///   - function: 功能
    /// - Returns: UIContextualAction
    static func _build(with title: String? = nil, style: UIContextualAction.Style = .normal, color: UIColor = .gray, image: UIImage? = nil, function: @escaping (() -> Void)) -> UIContextualAction {
        
        let contextualAction = UIContextualAction(style: style, title: title, handler: { (action, view, headler) in
            function()
            headler(true)
        })
        
        contextualAction.backgroundColor = color
        contextualAction.image = image
        
        return contextualAction
    }
}
