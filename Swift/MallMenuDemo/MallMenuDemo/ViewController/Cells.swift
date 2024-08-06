//
//  File.swift
//  Example
//
//  Created by iOS on 2024/8/6.
//

import UIKit

final class ItemCell: UICollectionViewCell, CellReusable {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    static var selectedIndexPath: IndexPath = .init()
    
    func configure(with indexPath: IndexPath) {
        titleLabel.text = "分類\(indexPath.row + 1)"
    }
}

final class TagCell: UICollectionViewCell, CellReusable {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with indexPath: IndexPath) {
        titleLabel.text = "分類\(ItemCell.selectedIndexPath.row + 1) - 細項\(indexPath.row + 1)"
    }
}

final class ContentCell: UICollectionViewCell, CellReusable {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with indexPath: IndexPath) {
        titleLabel.text = "分類\(ItemCell.selectedIndexPath.row + 1) - 內容\(indexPath.row + 1)"
    }
}
