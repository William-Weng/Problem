//
//  ViewController.swift
//  ImageCombine
//
//  Created by William-Weng on 2019/2/21.
//  Copyright © 2019年 William-Weng. All rights reserved.
//
/// [CGAffineTransform鏈式調用的問題](https://www.smwenku.com/a/5b8373012b71776c51e31ae7)
/// [Taking Charge of UIView Transforms in iOS Programming](http://www.informit.com/articles/article.aspx?p=1951182)

import UIKit

class ViewController: UIViewController {

    private let miniumSize = CGSize(width: 100, height: 100)
    
    @IBOutlet weak var copyView: UIView!
    @IBOutlet weak var copyImage: UIImageView!
    @IBOutlet weak var faceImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureRecognizerSetting(with: faceImage)
    }
    
    @IBAction func copyImage(_ sender: UIBarButtonItem) {
        copyImage.image = captureImage(with: copyView)
    }
}

// MARK: - @objc
extension ViewController: UIGestureRecognizerDelegate {
    
    /// 移動View (歸零)
    @objc private func handleDrag(_ pan: UIPanGestureRecognizer) {
        
        guard let panLocation = Optional.some(pan.translation(in: self.view)),
              let view = pan.view
        else {
            return
        }
        
        let newCenter = CGPoint(x: view.center.x + panLocation.x, y: view.center.y + panLocation.y)
        
        view.center = newCenter
        pan.setTranslation(.zero, in: pan.view)
    }
    
    /// 放大View (歸零)
    @objc private func handleZoom(_ pinch: UIPinchGestureRecognizer) {
        
        guard let view = pinch.view else { return }
        
        if pinch.state == .began || pinch.state == .changed {
            view.transform = view.transform.scaledBy(x: pinch.scale, y: pinch.scale)
            pinch.scale = 1.0
        }
    }
    
    /// 旋轉View (歸零)
    @objc private func rotationView(_ rotation: UIRotationGestureRecognizer) {
        
        guard let view = rotation.view else { return }
        
        view.transform = view.transform.rotated(by: rotation.rotation)
        rotation.rotation = 0
    }
}

// MARK: - 小工具
extension ViewController {
    
    /// 初始化GestureRecognizer
    private func gestureRecognizerSetting(with dragView: UIView) {
        
        let dragPan = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
        let zoomPinch = UIPinchGestureRecognizer(target: self, action: #selector(handleZoom(_:)))
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(rotationView(_:)))
        
        dragView.addGestureRecognizer(dragPan)
        dragView.addGestureRecognizer(zoomPinch)
        dragView.addGestureRecognizer(rotation)
    }
    
    /// 擷取UIView的畫面 => UIImage
    private func captureImage(with view: UIView) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        return image
    }
}
