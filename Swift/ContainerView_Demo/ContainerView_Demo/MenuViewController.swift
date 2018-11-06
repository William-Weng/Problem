//
//  MenuViewController.swift
//  ContainerView_Demo
//
//  Created by William-Weng on 2018/11/6.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    lazy var page1ViewController: Page1_ViewController = {
        self.storyboard!.instantiateViewController(withIdentifier: "Page1") as! Page1_ViewController
    }()
    
    lazy var page2ViewController: Page2_ViewController = {
        self.storyboard!.instantiateViewController(withIdentifier: "Page2") as! Page2_ViewController
    }()
    
    lazy var page3ViewController: Page3_ViewController = {
        self.storyboard!.instantiateViewController(withIdentifier: "Page3") as! Page3_ViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showPage1(_ sender: UIButton) {
        changePage(to: page1ViewController)
    }
    
    @IBAction func showPage2(_ sender: UIButton) {
        changePage(to: page2ViewController)
    }
    
    @IBAction func showPage3(_ sender: UIButton) {
        changePage(to: page3ViewController)
    }
    
    func changePage(to newViewController: UIViewController) {
        
        guard let menuViewController = ViewController.menuViewController,
              let containerView = menuViewController.mainView,
              var selectedViewController = menuViewController.mainVC
        else {
            return
        }
                
        selectedViewController.willMove(toParent: nil)
        selectedViewController.view.removeFromSuperview()
        selectedViewController.removeFromParent()
        
        menuViewController.addChild(newViewController)
        containerView.addSubview(newViewController.view)
        newViewController.view.frame = containerView.bounds
        newViewController.didMove(toParent: menuViewController)
        
        selectedViewController = newViewController
        
        menuViewController.hideMenuView()
    }
}
