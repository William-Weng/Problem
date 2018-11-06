//
//  Page2_ViewController.swift
//  ContainerView_Demo
//
//  Created by William-Weng on 2018/11/6.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

class Page2_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showMenu(_ sender: UIButton) {
        if let vc = ViewController.menuViewController {
            vc.showMenuView()
        }
    }

    @IBAction func hideMenu(_ sender: UIButton) {
        if let vc = ViewController.menuViewController {
            vc.hideMenuView()
        }
    }
}
