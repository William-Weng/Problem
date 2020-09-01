//
//  Utility.swift
//  UICollectionView_HelloWorld
//
//  Created by William.Weng on 2020/9/1.
//  Copyright © 2020 William.Weng. All rights reserved.
//

import UIKit

// MARK: - 自定義的Print
public func wwPrint<T>(_ msg: T, file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
        Swift.print("🚩 \((file as NSString).lastPathComponent)：\(line) - \(method) \n\t ✅ \(msg)")
    #endif
}

// MARK: - Utility (單例)
final class Utility: NSObject {
    static let shared = Utility()
    private override init() {}
}

// MARK: - Cell相關
extension Utility {
    
    /// 取得ReusableCollectionViewCell (let cell = reusableCellMaker(collectionView: collectionView, cellForItemAt: indexPath) as MyCollectionViewCell)
    func reusableCellMaker<T: ReusableCell>(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> T where T: UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else { fatalError("UICollectionViewCell Error") }
        return cell
    }
    
    /// 取得ReusableTableViewCell (let header = reusableHeaderMaker(collectionView: collectionView, cellForItemAt: indexPath) as MyCollectionReusableHeader)
    func reusableHeaderMaker<T: ReusableCell>(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> T where T: UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.identifier, for: indexPath) as? T else { fatalError("UICollectionReusableView Error") }
        return header
    }
    
    /// 取得ReusableTableViewCell (let footer = reusableFooterMaker(collectionView: collectionView, cellForItemAt: indexPath) as MyCollectionReusableFooter)
    func reusableFooterMaker<T: ReusableCell>(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> T where T: UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.identifier, for: indexPath) as? T else { fatalError("UICollectionReusableView Error") }
        return header
    }
}

