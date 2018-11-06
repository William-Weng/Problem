//
//  ViewController.swift
//  ContainerView_Demo
//
//  Created by William-Weng on 2018/11/6.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var slideView: UIView!
    @IBOutlet public weak var mainView: UIView!
    
    let mainSegue = "MainSegue"
    let menuSegue = "MenuSegue"

    var mainVC: UIViewController?
    var menuVC: MenuViewController?
    
    static var menuViewController: ViewController? = { return rootViewController() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == mainSegue { mainVC = segue.destination; return }
        if segue.identifier == menuSegue { menuVC = segue.destination as? MenuViewController; return }
    }
}

extension ViewController {
    
    static func rootViewController() -> ViewController? {
        return UIApplication.shared.keyWindow?.rootViewController as? ViewController
    }
    
    private func initView() {
        self.slideView.frame.origin = CGPoint.init(x: -500, y: 0)
    }
    
    public func hideMenuView() {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.slideView.frame.origin = CGPoint.init(x: -500, y: 0)
        }, completion: { isOK in
            print("hide => \(self.slideView.frame)")
        })
    }
    
    public func showMenuView() {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.slideView.frame.origin = CGPoint.init(x: 0, y: 0)
        }, completion: { isOK in
            print("show => \(self.slideView.frame)")
        })
    }
}
