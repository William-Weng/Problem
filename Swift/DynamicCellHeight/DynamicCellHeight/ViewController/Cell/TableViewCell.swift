//
//  TableViewCell.swift
//  Example
//
//  Created by William.Weng on 2023/12/15.
//

import UIKit
import WWPrint

class TableViewCell: UITableViewCell, WWExpandTableViewCell, CellReusable {
    
    static var expandRows: Set<IndexPath> = []
    
    var indexPath: IndexPath = []
    var cellHeightConstraint: NSLayoutConstraint?

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
        
    func configure(with indexPath: IndexPath) {
        
        cellHeightConstraint = heightConstraint
        
        heightConstraint.constant = 0
        self.indexPath = indexPath
        
        myLabel.text = "\(indexPath)"
    }
}
