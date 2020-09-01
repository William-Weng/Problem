//
//  MyCollectionViewCell.swift
//  UICollectionView_HelloWorld
//
//  Created by William.Weng on 2020/8/31.
//  Copyright © 2020 William.Weng. All rights reserved.
//

import UIKit

final class MyCollectionViewCell: UICollectionViewCell, ReusableCell {
    
    static var identifier: String  = String(describing: MyCollectionViewCell.self)
    
    @IBOutlet weak var titleLabel: UILabel!
    
    /// UI設定
    func configure(with indexPath: IndexPath) {
        
        let backgroundColor: UIColor = (indexPath.row % 2 == 0) ? .green : .lightGray
        
        self.titleLabel.text = "\(indexPath)"
        self.backgroundColor = backgroundColor
    }
}

final class MyCollectionReusableHeader: UICollectionReusableView, ReusableCell {
    
    static var identifier: String  = String(describing: MyCollectionReusableHeader.self)
    
    @IBOutlet weak var titleLabel: UILabel!
    
    /// UI設定
    func configure(with indexPath: IndexPath) {}
}


final class MyCollectionReusableFooter: UICollectionReusableView, ReusableCell {
    
    static var identifier: String  = String(describing: MyCollectionReusableFooter.self)
    
    @IBOutlet weak var titleLabel: UILabel!
    
    /// UI設定
    func configure(with indexPath: IndexPath) {}
}
