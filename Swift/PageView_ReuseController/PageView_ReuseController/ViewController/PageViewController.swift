//
//  PageViewController.swift
//  PageView_ReuseController
//
//  Created by William.Weng on 2018/6/25.
//  Copyright © 2018年 William.Weng. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    let oddViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OddViewController") as? OddViewController
    let evenViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EvenViewController") as? EvenViewController

    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetting()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - @UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        index += 1
        return nextViewContorller(with: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        index -= 1
        if (index < 0) { index = 0; return nil }
        return nextViewContorller(with: index)
    }
}

// MARK: - @UIPageViewControllerDelegate
extension PageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        view.isUserInteractionEnabled = false
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (finished || completed) {
            view.isUserInteractionEnabled = true
        }
    }
}

extension PageViewController {
    
    /// 初始設定
    private func viewSetting() {
        
        dataSource = self
        delegate = self
        setViewControllers([oddViewController!], direction: .reverse, animated: false, completion: nil)
        
        _ = oddViewController?.view
        _ = evenViewController?.view
        
        oddViewController?.myLabel.text = "\(index)"
    }
    
    /// 取得下一個ViewController
    private func nextViewContorller(with index: Int) -> UIViewController? {
        
        switch (index % 2) {
        case 0: oddViewController?.myLabel.text = "\(index)"; return oddViewController
        case 1: evenViewController?.myLabel.text = "\(index)"; return evenViewController
        default: return nil
        }
    }
}
