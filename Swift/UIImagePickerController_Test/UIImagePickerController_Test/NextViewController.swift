//
//  NextViewController.swift
//  UIImagePickerController_Test
//
//  Created by William-Weng on 2018/3/10.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func 這樣不行(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
