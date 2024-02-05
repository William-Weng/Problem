//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2024/1/1.
//

import UIKit
import WWPrint

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let classType = NSClassFromString("UIMoreNavigationController") as! NSObject.Type
        let navigationType = String(describing: type(of: navigationController.self))
        
        wwPrint(classType.init())
        wwPrint(navigationType)
        
        guard navigationController?.viewControllers.count == 2,
              let vc = navigationController?.viewControllers.last
        else {
            return
        }
        
        navigationController?.viewControllers = [vc]
    }
}
