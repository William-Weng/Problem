//
//  MainViewController.swift
//  PageView_ReuseController
//
//  Created by William.Weng on 2018/6/25.
//  Copyright © 2018年 William.Weng. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var pageViewController: PageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _pageViewController = segue.destination as? PageViewController {
            pageViewController = _pageViewController
        }
    }
}
