
//
//  SubViewController.swift
//  SKStoreProductViewController
//
//  Created by William.Weng on 2020/9/4.
//  Copyright © 2020 William.Weng. All rights reserved.
//

import UIKit
import StoreKit

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

final class SubViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transparentBackgroundSetting(UIColor(white: 0, alpha: 0.3))
        
        let storeProductViewController = MySKStoreProductViewController()
        let parameters = iTunesItemParametersMaker(with: 304878510)
        
        storeProductViewController.loadProduct(withParameters: parameters, completionBlock: nil)
        
        present(storeProductViewController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismiss(animated: true, completion: nil)
    }
    
    /// AppStore的Identifier => [SKStoreProductParameterITunesItemIdentifier: 3939889]
    func iTunesItemParametersMaker(with identifier: NSNumber) -> [String: NSNumber] {
        return [SKStoreProductParameterITunesItemIdentifier: identifier]
    }
}

// MARK: - SKStoreProductViewController
final class MySKStoreProductViewController: SKStoreProductViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
        
        /// 行不通 (✖)
        transparentBackgroundSetting(UIColor(white: 0, alpha: 0.3))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureHeight(UIScreen.main.bounds.height * 0.5)
        
        /// 行不通 (✖)
        view.backgroundColor = .clear
    }
    
    /// 初始化設定
    private func initSetting() {
        
        view.layer.cornerRadius = 20.0
        view.clipsToBounds = true
        
        /// 行不通 (✖)
        view.layer.backgroundColor = UIColor.clear.cgColor
        
        delegate = self
    }
    
    /// 設定view.frame
    private func configureHeight(_ height: CGFloat) {

        let bounds = UIScreen.main.bounds
        let frame = CGRect(origin: CGPoint(x: 0, y: bounds.height - height), size: CGSize(width: bounds.width, height: height))
                
        view.frame = frame
    }
}

// MARK: - SKStoreProductViewControllerDelegate
extension MySKStoreProductViewController: SKStoreProductViewControllerDelegate {
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIViewController (class function)
extension UIViewController {
    
    /// 設定UIViewController透明背景 (當Alert用)
    func transparentBackgroundSetting(_ backgroundColor: UIColor = .clear) {
        view.backgroundColor = backgroundColor
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .coverVertical
    }
}
