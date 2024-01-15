//
//  NextViewController.swift
//  SwiftCombineFirst
//
//  Created by iOS on 2024/1/15.
//

import UIKit

// MARK: - 測試頁
final class NextViewController: UIViewController {

    var viewModel: RegistrationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
}

// MARK: - 小工具
private extension NextViewController {
    
    /// 初始化設定
    func initSetting() {
        title = viewModel.username
        viewModel.clean()   // 如果不讓上一頁的cancellables = []，這裡也會清除上一頁的輸入框的值
    }
}
