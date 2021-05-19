//
//  Extension+.swift
//  DynamicPageViewController
//
//  Created by William.Weng on 2021/5/19.
//

import UIKit

// MARK: - 自定義的Print
public func wwPrint<T>(_ msg: T, file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
        Swift.print("🚩 \((file as NSString).lastPathComponent)：\(line) - \(method) \n\t ✅ \(msg)")
    #endif
}

// MARK: - Collection (override class function)
extension Collection {

    /// [為Array加上安全取值特性 => nil](https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings)
    subscript(safe index: Index) -> Element? { return indices.contains(index) ? self[index] : nil }
}

// MARK: - UIStoryboard (static function)
extension UIStoryboard {
    
    /// 由UIStoryboard => ViewController
    /// - Parameters:
    ///   - name: Storyboard的名稱 => Main.storyboard
    ///   - storyboardBundleOrNil: Bundle名稱
    /// - Returns: T (泛型) => UIViewController
    static func _instantiateViewController<T: UIViewController>(name: String = "Main", bundle storyboardBundleOrNil: Bundle? = nil, identifier: String = String(describing: T.self)) -> T {
        
        let viewController = UIStoryboard(name: name, bundle: storyboardBundleOrNil).instantiateViewController(identifier: identifier) as T
        return viewController
    }
}

// MARK: - UIPageViewController (class function)
extension UIPageViewController {
    
    /// 初始化Protocal
    /// - Parameter this: UIPageViewControllerDelegate & UIPageViewControllerDataSource
    func _delegateAndDataSource(with this: UIPageViewControllerDelegate & UIPageViewControllerDataSource) {
        self.delegate = this
        self.dataSource = this
    }
    
    /// 重新載入
    /// - Parameter dataSource: UIPageViewControllerDataSource
    func _reloadData(dataSource: UIPageViewControllerDataSource) {
        
        self.dataSource = nil
        self.dataSource = dataSource
    }
    
    /// 切換頁面
    /// - Parameters:
    ///   - viewControllers: [UIViewController]
    ///   - page: 第幾頁
    ///   - direction: 切換頁目的方向
    ///   - animated: 動畫顯示
    ///   - completion: 是否完成
    func _changePage(viewControllers: [UIViewController], index: Int, direction: UIPageViewController.NavigationDirection = .forward, animated: Bool = false, completion: @escaping (Bool) -> Void) {
        
        if let pageViewController = viewControllers[safe: index] {
            self.setViewControllers([pageViewController], direction: direction, animated: animated) { isComplete in
                completion(isComplete)
            }
        }
    }
    
    /// 下一頁的PageViewController => pageViewController(_:viewControllerBefore:) / pageViewController(_:viewControllerAfter:)
    /// - Parameters:
    ///   - viewControllers: [UIViewController]
    ///   - viewController: viewControllerBefore / viewControllerAfter的viewController
    ///   - index: +1 (下一頁) / -1 (上一頁)
    /// - Returns: UIViewController?
    func _nextPage(viewControllers: [UIViewController], next viewController: UIViewController, addIndex index: Int) -> UIViewController? {
        
        guard let currentPage = viewControllers.firstIndex(of: viewController),
              let nextViewController = _selectedPage(viewControllers: viewControllers, pageIndex: currentPage + index)
        else {
            return nil
        }

        return nextViewController
    }
    
    ///  取得當前的ViewController Index => pageViewController(_:didFinishAnimating:previousViewControllers:transitionCompleted:)
    /// - Parameter viewcontrollers: [UIViewController]
    /// - Returns: Int?
    func _currentPage(with viewcontrollers: [UIViewController]) -> Int? {
        
        guard let currentViewController = self.viewControllers?.first,
              let currentPageIndex = viewcontrollers.firstIndex(of: currentViewController)
        else {
            return nil
        }

        return currentPageIndex
    }
}

// MARK: - UIPageViewController (private class function)
extension UIPageViewController {
    
    /// 產生要顯示的PageView
    /// - Parameter index: 要顯示哪一頁
    /// - Returns: UIViewController?
    private func _selectedPage(viewControllers: [UIViewController], pageIndex: Int) -> UIViewController? {
        
        if viewControllers.count <= 1 { return nil }
        if pageIndex < 0 { return viewControllers.last }
        if pageIndex >= viewControllers.count { return viewControllers.first }
        
        return viewControllers[pageIndex]
    }
}

