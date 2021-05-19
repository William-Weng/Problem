//
//  MyPageViewController.swift
//  DynamicPageViewController
//
//  Created by William.Weng on 2021/5/19.
//

import UIKit

// MARK: - UIPageViewController
final class MyPageViewController: UIPageViewController {

    weak var myDelegate: MyPageViewDelegate?
    
    private var myPageViewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource
extension MyPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let _viewController = pageViewController._nextPage(viewControllers: myPageViewControllers, next: viewController, addIndex: 1) as? DemoViewController
        
        // [不允許2頁模式的循環](https://www.thinbug.com/q/47514111)
        if (myPageViewControllers.count == 2 && _viewController?.view.tag == 0) { return nil }
        return _viewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if (myPageViewControllers.count == 2) { return nil }
        
        let _viewController = pageViewController._nextPage(viewControllers: myPageViewControllers, next: viewController, addIndex: -1) as? DemoViewController
        return _viewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentPage = pageViewController._currentPage(with: myPageViewControllers) else { return }
        self.myDelegate?.currentPage(currentPage)
    }
}

// MARK: - 小工具 (class function)
extension MyPageViewController {
    
    /// 添加測試用ViewController
    /// - Parameters:
    ///   - backgroundColor: 背景色
    func appendPageViewController(backgroundColor: UIColor) {
        
        let pageNumber = myPageViewControllers.count
        
        self.myPageViewControllers.append(demoViewControllerMaker(backgroundColor: backgroundColor, tag: pageNumber))
        self.myDelegate?.numberOfPages(myPageViewControllers.count)
        
        self._reloadData(dataSource: self)
    }
    
    /// 切換頁面
    /// - Parameters:
    ///   - page: 第幾頁
    ///   - direction: 切換頁目的方向
    ///   - animated: 動畫顯示
    ///   - completion: 是否完成
    func changePage(index: Int, direction: UIPageViewController.NavigationDirection = .forward, animated: Bool = false, completion: @escaping (Bool) -> Void) {
        
        self._changePage(viewControllers: myPageViewControllers, index: index) { isCompletion in
            completion(isCompletion)
        }
    }
}

// MARK: - 小工具 (private class function)
extension MyPageViewController {
    
    /// 初始化設定
    private func initSetting() {
        
        self._delegateAndDataSource(with: self)
        
        self.appendPageViewController(backgroundColor: .green)
        self.myDelegate?.numberOfPages(myPageViewControllers.count)
        
        self.changePage(index: 0) { isCompletion in
            wwPrint(isCompletion)
        }
    }
    
    /// 產生測試頁
    /// - Parameters:
    ///   - backgroundColor: 背景色
    ///   - tag: Index => 註記用
    /// - Returns: DemoViewController
    private func demoViewControllerMaker(backgroundColor: UIColor, tag: Int) -> DemoViewController {
        
        let viewController = UIStoryboard._instantiateViewController() as DemoViewController
        let text = "第\(myPageViewControllers.count + 1)頁"

        viewController.view.backgroundColor = backgroundColor
        viewController.myLabel.text = text
        viewController.view.tag = tag
        
        return viewController
    }
}
