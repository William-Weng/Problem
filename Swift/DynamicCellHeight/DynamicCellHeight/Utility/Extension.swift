//
//  Extension.swift
//  Example
//
//  Created by William.Weng on 2023/9/11.
//

import UIKit

extension UITableView {
    
    /// 註冊Cell (使用Xib)
    /// - Parameters:
    ///   - cellClass: 符合CellReusable的Cell
    ///   - bundle: Bundle
    func _registerNibCell<T: CellReusable>(with cellClass: T.Type, bundle: Bundle? = nil) { register(UINib(nibName: T.identifier, bundle: bundle), forCellReuseIdentifier: T.identifier) }
    
    /// 取得UITableViewCell
    /// - let cell = tableview._reusableCell(at: indexPath) as MyTableViewCell
    /// - Parameter indexPath: IndexPath
    /// - Returns: 符合CellReusable的Cell
    func _reusableCell<T: CellReusable>(at indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else { fatalError("UITableViewCell Error") }
        return cell
    }
}
