//
//  ViewController.swift
//  DynamicPageViewController
//
//  Created by William.Weng on 2021/5/19.
//

import UIKit

// MARK: - 更新PageControl的Protocol
protocol MyPageViewDelegate: AnyObject {
    
    /// 設定PageControl的總數量
    func numberOfPages(_ number: Int)
    
    /// 設定PageControl的現在在哪一頁
    func currentPage(_ page: Int)
}

// MARK: - UIViewController
final class ViewController: UIViewController {

    @IBOutlet weak var myContainerView: UIView!
    @IBOutlet weak var myPageControl: UIPageControl!
    
    private var myPageController: MyPageViewController?
    
    override func viewDidLoad() { super.viewDidLoad() }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        initSetting(for: segue, sender: sender)
    }
    
    @IBAction func appendPage(_ sender: UIBarButtonItem) {
        myPageController?.appendPageViewController(backgroundColor: .green)
    }
    
    @IBAction func changePageView(_ sender: UIPageControl) {
        myPageController?.changePage(index: sender.currentPage, completion: { isCompletion in
            wwPrint(isCompletion)
        })
    }
}

// MARK: - MyPageViewDelegate
extension ViewController: MyPageViewDelegate {
    
    func numberOfPages(_ number: Int) { myPageControl.numberOfPages = number }
    func currentPage(_ number: Int) { myPageControl.currentPage = number }
}

// MARK: - 小工具
extension ViewController {
    
    /// 初始化UIPageViewController
    /// - Parameters:
    ///   - segue: UIStoryboardSegue
    ///   - sender: Any?
    private func initSetting(for segue: UIStoryboardSegue, sender: Any?) {
        myPageController = segue.destination as? MyPageViewController
        myPageController?.myDelegate = self
    }
}
