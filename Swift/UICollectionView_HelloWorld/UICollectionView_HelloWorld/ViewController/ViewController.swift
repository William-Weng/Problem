//
//  ViewController.swift
//  UICollectionView_HelloWorld
//
//  Created by William.Weng on 2020/8/31.
//  Copyright © 2020 William.Weng. All rights reserved.
//
/// [UICollectionView | Apple Developer Documentation](https://developer.apple.com/documentation/uikit/uicollectionview)
/// [Swift從零開始-Day6：UICollectionView基礎學習](https://ithelp.ithome.com.tw/articles/10193685)
/// [UICollectionView iOS 10 New Features - UICollectionView Cell生命週期變化](https://sxgfxm.github.io/blog/2016/10/18/uicollectionview-ios10-new-features/)
/// [網格 UICollectionView](https://itisjoe.gitbooks.io/swiftgo/content/uikit/uicollectionview.html)
/// [一篇較為詳細的 UICollectionView 使用方法總結](https://zhang759740844.github.io/2017/07/27/UICollectionView完全解析/)
/// [使用純 Code 的方式建立 UICollectionView](https://medium.com/@mikru168/ios-uicollectionview-af8e3d57f98c)
/// [ios:真實的iPhone XR螢幕分辨率與swift提供的螢幕分辨率不同嗎？](https://t.codebug.vip/questions-1789149.htm)
/// [iOS Device Display Summary](https://developer.apple.com/library/archive/documentation/DeviceInformation/Reference/iOSDeviceCompatibility/Displays/Displays.html)
/// [UICollectionView Tutorial: Reusable Views, Selection and Reordering](https://www.raywenderlich.com/9477-uicollectionview-tutorial-reusable-views-selection-and-reordering)

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var myCollectionView: UICollectionView!
        
    private var currentLineCount: Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        view.layoutIfNeeded()
        changeFlowLayout(with: currentLineCount, isAnimated: false)
    }

    @IBAction func changeLayout1(_ sender: UIBarButtonItem) {
        currentLineCount = 5
        changeFlowLayout(with: currentLineCount, isAnimated: true)
    }
    
    @IBAction func changeLayout2(_ sender: UIBarButtonItem) {
        currentLineCount = 3
        changeFlowLayout(with: currentLineCount, isAnimated: true)
    }
    
    @IBAction func changeCustomLayout(_ sender: UIBarButtonItem) {
        let flowLayout = MyCollectionViewFlowLayout()
        myCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int { return 3 }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return 10 }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = Utility.shared.reusableCellMaker(collectionView: collectionView, cellForItemAt: indexPath) as MyCollectionViewCell
        cell.configure(with: indexPath)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView = UICollectionReusableView()
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            reusableView = Utility.shared.reusableHeaderMaker(collectionView: collectionView, cellForItemAt: indexPath) as MyCollectionReusableHeader
        case UICollectionView.elementKindSectionFooter:
            reusableView = Utility.shared.reusableFooterMaker(collectionView: collectionView, cellForItemAt: indexPath) as MyCollectionReusableFooter
        default:
            break
        }

        return reusableView
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        wwPrint("didSelectItemAt => \(indexPath)")
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        wwPrint("willDisplay => \(indexPath)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        wwPrint("didEndDisplaying => \(indexPath)")
    }
}

// MARK: - 小工具
extension ViewController {
    
    /// 初始化設定
    private func initConfigure() {
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
    }
    
    /// 切換FlowLayout
    private func changeFlowLayout(with count: Int, isAnimated: Bool = false, completion: ((Bool) -> Void)? = nil) {
        
        let flowLayout = flowLayoutMaker(with: count)
        myCollectionView.setCollectionViewLayout(flowLayout, animated: isAnimated, completion: completion)
    }
    
    /// 基本的FlowLayout設定
    private func flowLayoutMaker(with count: Int, scrollDirection: UICollectionView.ScrollDirection = .vertical) -> UICollectionViewFlowLayout {
        
        let flowLayout = UICollectionViewFlowLayout()
        let viewFrame = myCollectionView.frame
        let itemGap: CGFloat = 10
        let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let itemAverageWidth = (viewFrame.width - sectionInset.left - sectionInset.right - itemGap * CGFloat(count - 1)) / CGFloat(count)
    
        flowLayout.scrollDirection = scrollDirection
        flowLayout.itemSize = CGSize(width: floor(itemAverageWidth), height: 44.0)
        
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = itemGap
        
        flowLayout.sectionInset = sectionInset
        flowLayout.headerReferenceSize = CGSize(width: viewFrame.width, height: 40)
        flowLayout.footerReferenceSize = CGSize(width: viewFrame.width, height: 40)

        return flowLayout
    }
}

final class MyCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
}
