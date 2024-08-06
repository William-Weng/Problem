//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2024/1/1.
//

import UIKit
import WWCompositionalLayout

// MARK: - ViewController
final class ViewController: UIViewController {
    
    private enum CollectionViewType: Int {
        case item = 101
        case tag = 201
        case content = 301
    }
    
    private let badgeViewKey = "Badge"
    private let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    private let edgeInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
    private var currentLayoutIndex = 0

    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        guard let type = CollectionViewType(rawValue: collectionView.tag) else { return 0 }

        let count: Int
        
        switch type {
        case .item: count = 1
        case .tag: count = 1
        case .content: count = 5
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let type = CollectionViewType(rawValue: collectionView.tag) else { return 0 }
        
        let number: Int
        
        switch type {
        case .item: number = 20
        case .tag: number = 5
        case .content: number = (section + 1) * 10
        }
        
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let type = CollectionViewType(rawValue: collectionView.tag) else { fatalError() }

        let cell: UICollectionViewCell & CellReusable
        
        switch type {
        case .item: cell = collectionView._reusableCell(at: indexPath) as ItemCell
        case .tag: cell = collectionView._reusableCell(at: indexPath) as TagCell
        case .content: cell = collectionView._reusableCell(at: indexPath) as ContentCell
        }
        
        cell.configure(with: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == "\(WWCompositionalLayout.ReusableSupplementaryViewKind.header)" {
            let header = collectionView._reusableSupplementaryView(at: indexPath, ofKind: .header) as ReusableHeader
            header.configure(with: indexPath)
            return header
        }
        
        return UICollectionReusableView()
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let type = CollectionViewType(rawValue: collectionView.tag) else { return }
        
        switch type {
        case .item:
            ItemCell.selectedIndexPath = indexPath

            let selectedIndexPath = IndexPath(row: 3, section: 0)
            contentCollectionView.scrollToItem(at: selectedIndexPath, at: .bottom, animated: true)
            contentCollectionView.reloadData()
            
        case .tag:
            
            // 完全不知道為什麼會這樣？
            var selectedIndexPath = IndexPath(row: (indexPath.section + 1) * 10 + 3, section: indexPath.row)
            if indexPath.row == 0 { selectedIndexPath = IndexPath(row: 3, section: 0) }
            
            contentCollectionView.scrollToItem(at: selectedIndexPath, at: .bottom, animated: true)
            
        case .content: break
        }
    }
}

// MARK: - 小工具
private extension ViewController {
    
    func initSetting() {
        
        itemCollectionView._delegateAndDataSource(with: self)
        tagCollectionView._delegateAndDataSource(with: self)
        contentCollectionView._delegateAndDataSource(with: self)
        
        itemCollectionView.setCollectionViewLayout(tableViewLayout()!, animated: true)
        tagCollectionView.setCollectionViewLayout(bookshelfLayout()!, animated: true)
        contentCollectionView.setCollectionViewLayout(photoAlbumLayout()!, animated: true)
        
        itemCollectionView._hideScrollIndicator()
        tagCollectionView._hideScrollIndicator()
        contentCollectionView._hideScrollIndicator()
        
        ItemCell.selectedIndexPath = IndexPath(row: 0, section: 0)
    }
}

// MARK: - UICollectionViewCompositionalLayout
private extension ViewController {
    
    func tableViewLayout() -> UICollectionViewCompositionalLayout? {
        
        let layout = WWCompositionalLayout.shared
            .addItem(width: .fractionalWidth(1.0), height: .absolute(64), contentInsets: edgeInsets, badgeSetting: nil)
            .setGroup(width: .fractionalWidth(1.0), height: .absolute(64), scrollingDirection: .horizontal)
            .setSection(with: .none, contentInsets: contentInsets)
            .build()
        
        return layout
    }
    
    func bookshelfLayout(with count: CGFloat = 3.0) -> UICollectionViewCompositionalLayout? {
        
        let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 83.33)
        
        let layout = WWCompositionalLayout.shared
            .addItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0), contentInsets: edgeInsets, badgeSetting: nil)
            .setGroup(width: .fractionalWidth(1.0/count), height: .fractionalHeight(1.0), scrollingDirection: .vertical)
            .setSection(with: .continuousGroupLeadingBoundary, contentInsets: contentInsets)
            .build()
        
        return layout
    }
    
    func photoAlbumLayout() -> UICollectionViewCompositionalLayout? {
        
        let layout = WWCompositionalLayout.shared
            .addItem(width: .fractionalWidth(1/3), height: .absolute(120), contentInsets: edgeInsets)
            .setGroup(width: .fractionalWidth(1.0), height: .absolute(120), scrollingDirection: .horizontal)
            .setSection(with: .none, contentInsets: contentInsets)
            .setHeader(width: .fractionalWidth(1.0), height: .absolute(30))
            .build()
        
        return layout?._register(with: contentCollectionView, supplementaryViewClass: ReusableHeader.self, ofKind: .header)
    }
}
