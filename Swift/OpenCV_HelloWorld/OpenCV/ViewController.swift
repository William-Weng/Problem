//
//  ViewController.swift
//  OpenCV
//
//  Created by 翁禹斌(William.Weng) on 2018/8/10.
//  Copyright © 2018年 翁禹斌(William.Weng). All rights reserved.
//

import AVFoundation
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var openCVImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        openCVImageView.image = OpenCVMethods.searchFace(originalImageView.image!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

