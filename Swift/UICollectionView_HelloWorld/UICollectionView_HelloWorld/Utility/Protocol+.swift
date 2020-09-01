//
//  Protocol+.swift
//  UICollectionView_HelloWorld
//
//  Created by William.Weng on 2020/9/1.
//  Copyright © 2020 William.Weng. All rights reserved.
//

import UIKit

// MARK: - 可重複使用的Cell (UITableViewCell / UICollectionViewCell)
protocol ReusableCell: class {
    static var identifier: String { get }
}
