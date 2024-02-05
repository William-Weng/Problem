//
//  WWTabBarController.swift
//  Example
//
//  Created by iOS on 2024/2/5.
//

import UIKit
import WWPrint

// MARK: @Class的主體
final class WWTabBarController: UITabBarController {

    typealias tabBarImage = (normal: UIImage?, selected: UIImage?)
    
    /* TabBarItem的底View */
    var tabBarItemBackgroundViewArray = [UIView]()
    
    /* TabBarItem的按下後的圖示 */
    var tabBarItemBackgroundImageArray = [tabBarImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarItemShadowView()
        self.tabBar.isHidden = true
        // self.moreNavigationController.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {}
    
    @objc func didSelectedIndex(_ tap: UITapGestureRecognizer) {
        guard let index = tap.view?.tag else { return }
        self.selectedIndex = index
    }
}

// MARK: @小工具
extension WWTabBarController {
    
    func tabBarItemShadowView() {
                
        guard let tabBarItems = viewControllers else { return }
        
        let tabbarView = WWTabbarView(frame: tabBar.frame)
        
        for index in 0..<tabBarItems.count {
            
            let _shadowView_ = WWTabbarItemView()
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelectedIndex))
            
            _shadowView_.frame = .zero
            _shadowView_.backgroundColor = UIColor._random().withAlphaComponent(0.2)
            _shadowView_.isUserInteractionEnabled = true
            _shadowView_.tag = index
            _shadowView_.addGestureRecognizer(tapGestureRecognizer)
                        
            tabbarView.stackView.addArrangedSubview(_shadowView_)
            tabBarItemBackgroundViewArray.append(_shadowView_)
        }
        
        let fullSize = tabbarView.frame.size
        let tap = tabbarView.stackView.frame.minX
        let point = CGPoint(x: tap, y: tap)
        let size = CGSize(width: fullSize.width - tap * 2, height: fullSize.height - tap * 2)
        let path = UIBezierPath._capsule(CGRect(origin: point, size: size))
        let makeLayer = CAShapeLayer()
        
        makeLayer.path = path.cgPath
        tabbarView.layer.mask = makeLayer
        
        view.insertSubview(tabbarView, at: 1)
    }
}

