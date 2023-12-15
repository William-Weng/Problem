//
//  Protocol.swift
//  Example
//
//  Created by William.Weng on 2023/12/15.
//

import UIKit

protocol CellReusable: AnyObject {
    
    static var identifier: String { get }
    var indexPath: IndexPath { get set }
    
    func configure(with indexPath: IndexPath)
}

protocol WWExpandTableViewCell: AnyObject {
    
    static var expandRows: Set<IndexPath> { get set }
    var cellHeightConstraint: NSLayoutConstraint? { get set }
    
    static func exchangeExpandState(_ tableView: UITableView, indexPath: IndexPath)
}

extension WWExpandTableViewCell {
    
    /// 交換折疊狀態
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: IndexPath
    static func exchangeExpandState(_ tableView: UITableView, indexPath: IndexPath) {
        
        let cell = tableView.visibleCells.first { cell in
            guard let cell = cell as? CellReusable,
                  cell.indexPath == indexPath
            else {
                return false
            }
            return true
            
        } as? WWExpandTableViewCell
                
        if !Self.expandRows.contains(indexPath) {
            Self.expandRows.insert(indexPath)
            cell?.cellHeightConstraint?.constant = 0
        } else {
            Self.expandRows.remove(indexPath)
            cell?.cellHeightConstraint?.constant = 250
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension CellReusable {
    static var identifier: String { return String(describing: Self.self) }
    var indexPath: IndexPath { return [] }
}
