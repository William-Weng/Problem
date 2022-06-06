//
//  ViewController.swift
//  RichPushNotification
//
//  Created by William.Weng on 2022/6/5.
//

import UIKit
import WWLog

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func test(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        WWLog.shared.log(appDelegate.userInfo)
    }
}

