//
//  Protocol.swift
//  Example
//
//  Created by William.Weng on 2023/12/15.
//

import UIKit
import WWPrint

protocol CellReusable: AnyObject {
    
    static var identifier: String { get }
    var indexPath: IndexPath { get set }
    
    func configure(with indexPath: IndexPath)
}

protocol CellExpandable: AnyObject {
    
    static var expandRows: Set<IndexPath> { get set }
    var heightConstraint: NSLayoutConstraint? { get set }

    static func exchangeExpandState(_ tableView: UITableView, indexPath: IndexPath, isSingle: Bool)
    
    func expandView() -> WWExpandView?
}

extension CellExpandable {
    
    /// 交換折疊狀態
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: IndexPath
    static func exchangeExpandState(_ tableView: UITableView, indexPath: IndexPath, isSingle: Bool) {
        
        let visibleCells = tableView.visibleCells.compactMap { cell -> (CellReusable & CellExpandable)? in
            guard let cell = cell as? CellReusable & CellExpandable else { return nil }
            return cell
        }
        
        let selectedCell = visibleCells.first { cell in
            return cell.indexPath == indexPath
        }

        UIView.animate(withDuration: 0.25, delay: 0) {
            
            if (isSingle) {
                visibleCells.forEach { cell in
                    if (!cell.expandView()!.isHidden) { cell.expandView()?.isHidden = true }
                }
            }
            
            if !Self.expandRows.contains(indexPath) {
                Self.expandRows.insert(indexPath)
                selectedCell?.expandView()?.isHidden = true
            } else {
                Self.expandRows.remove(indexPath)
                selectedCell?.expandView()?.isHidden = false
            }
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension CellReusable {
    static var identifier: String { return String(describing: Self.self) }
    var indexPath: IndexPath { return [] }
}
