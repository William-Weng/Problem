//
//  TableViewCell.swift
//  Example
//
//  Created by William.Weng on 2023/12/15.
//

import UIKit
import WWPrint

class WWExpandView: UIView {}

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var myExpandView: WWExpandView!
    @IBOutlet weak var myLabel: UILabel!
    
    static var expandRows: Set<IndexPath> = []
    
    var indexPath: IndexPath = []
    var heightConstraint: NSLayoutConstraint?
}

extension TableViewCell: CellReusable {
    
    func configure(with indexPath: IndexPath) {
        self.indexPath = indexPath
        myLabel.text = "\(indexPath)"
        myExpandView.isHidden = true
        Self.expandRows.insert(indexPath)
    }
}

extension TableViewCell: CellExpandable {
    
    func expandView() -> WWExpandView? {
        return myExpandView
    }
}
