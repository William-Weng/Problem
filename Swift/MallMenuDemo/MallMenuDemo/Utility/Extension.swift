//
//  Extension.swift
//  Example
//
//  Created by iOS on 2024/8/6.
//

import UIKit
import WWCompositionalLayout

// MARK: - 可重複使用的Cell (UITableViewCell / UICollectionViewCell)
protocol CellReusable: AnyObject {
    
    static var identifier: String { get }           /// Cell的Identifier
    var indexPath: IndexPath { get }                /// Cell的IndexPath
    
    /// Cell的相關設定
    /// - Parameter indexPath: IndexPath
    func configure(with indexPath: IndexPath)
}

// MARK: - 預設 identifier = class name (初值)
extension CellReusable {
    static var identifier: String { return String(describing: Self.self) }
    var indexPath: IndexPath { return [] }
}

// MARK: - UICollectionView (function)
extension UICollectionView {
    
    /// 初始化Protocal
    /// - Parameter this: UICollectionViewDelegate & UICollectionViewDataSource
    func _delegateAndDataSource(with this: UICollectionViewDelegate & UICollectionViewDataSource) {
        self.delegate = this
        self.dataSource = this
    }
    
    /// 清除Protocal
    func _removeDelegateAndDataSource() {
        self.delegate = nil
        self.dataSource = nil
    }
    
    /// 隱藏滾動條
    /// - Parameter isHidden: Bool
    func _hideScrollIndicator(_ isHidden: Bool = true) {
        showsHorizontalScrollIndicator = !isHidden
        showsVerticalScrollIndicator = !isHidden
    }
    
    /// 取得UICollectionViewCell
    /// - let cell = collectionView._reusableCell(at: indexPath) as MyCollectionViewCell
    /// - Parameter indexPath: IndexPath
    /// - Returns: 符合CellReusable的Cell
    func _reusableCell<T: CellReusable>(at indexPath: IndexPath) -> T where T: UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else { fatalError("UICollectionViewCell Error") }
        return cell
    }
    
    /// 註冊Cell (使用xib / code)
    /// - Parameters:
    ///   - cellClass: 符合CellReusable的Cell
    ///   - kind: String
    func  _registerSupplementaryView<T: CellReusable>(cellClass: T.Type, ofKind kind: WWCompositionalLayout.ReusableSupplementaryViewKind) {
        register(T.self, forSupplementaryViewOfKind: "\(kind)", withReuseIdentifier: T.identifier)
    }
    
    /// 取得UICollectionReusableView
    /// - let header = collectionView._reusableHeader(at: indexPath, forKind = .header) as MyCollectionReusableHeader
    /// - Parameters:
    ///   - indexPath: IndexPath
    ///   - kind: Constant.ReusableSupplementaryViewKind
    /// - Returns: 符合CellReusable的ReusableView
    func _reusableSupplementaryView<T: CellReusable>(at indexPath: IndexPath, ofKind kind: WWCompositionalLayout.ReusableSupplementaryViewKind) -> T where T: UICollectionReusableView {
        guard let supplementaryView = dequeueReusableSupplementaryView(ofKind: "\(kind)", withReuseIdentifier: T.identifier, for: indexPath) as? T else { fatalError("UICollectionReusableView Error") }
        return supplementaryView
    }
    
    /// [資料新增或刪除時的動作設定 - performBatchUpdates() => beginUpdates() + endUpdates()](https://ithelp.ithome.com.tw/articles/10225747)
    /// - Parameters:
    ///   - updates: [(() -> Void)?](https://medium.com/@howardsun/uicollectionview-performbatchupdates-最大的秘密-7fb214c81d17)
    ///   - completion: [((Bool) -> Void)?](https://developer.apple.com/documentation/uikit/uicollectionview/1618045-performbatchupdates)
    func _performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        
        self.performBatchUpdates {
            updates?()
        } completion: { isCompleted in
            completion?(isCompleted)
        }
    }
}


// MARK: - UICollectionViewLayout (class function)
extension UICollectionViewCompositionalLayout {
        
    func _register<T: CellReusable>(with collectionView: UICollectionView, supplementaryViewClass: T.Type, ofKind kind: WWCompositionalLayout.ReusableSupplementaryViewKind) -> Self {
        collectionView._registerSupplementaryView(cellClass: supplementaryViewClass, ofKind: kind)
        return self
    }
    
    func _register(with viewClass: AnyClass?, ofKind kind: WWCompositionalLayout.ReusableSupplementaryViewKind) -> Self {
        self.register(viewClass, forDecorationViewOfKind: "\(kind)")
        return self
    }
}

// MARK: - 載入Xib的Protocol
protocol NibOwnerLoadable: AnyObject {
    static var nibName: String { get }
    static var nib: UINib { get }
}

// MARK: - 直接設定初值
extension NibOwnerLoadable {
    static var nibName: String { Self.nibNameMaker() }
    static var nib: UINib { Self.nibMaker() }
}

// MARK: - 開放使用的function
extension NibOwnerLoadable where Self: UIView {

    /// 載入XibView (加上constraint)
    func loadViewFromXib() {
        guard let contentView = xibContentViewMaker() else { fatalError("載入XibView失敗") }
        addSubview(contentView)
        xibConstraintSetting(contentView: contentView)
    }
}

// MARK: - 小工具
extension NibOwnerLoadable {

    /// 取得xib的name
    /// - Returns: String
    private static func nibNameMaker() -> String { return String(describing: Self.self) }
    
    /// 讀取xib
    /// - Returns: UINib
    private static func nibMaker() -> UINib { return UINib(nibName: nibNameMaker(), bundle: Bundle(for: Self.self)) }

    /// 取得xib的contentView
    /// - Returns: UIView?
    private func xibContentViewMaker() -> UIView? {

        guard let views = Self.nib.instantiate(withOwner: self, options: nil) as? [UIView],
              let contentView = views.first
        else {
            return nil
        }

        return contentView
    }
}

// MARK: - 小工具 (UIView)
extension NibOwnerLoadable where Self: UIView {
    
    /// 設定xib的constraint
    /// - Parameter contentView: 要加上去的View
    private func xibConstraintSetting(contentView: UIView) {

        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
