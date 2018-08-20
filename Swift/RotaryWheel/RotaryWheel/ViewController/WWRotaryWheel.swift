//
//  WWRotaryWheel.swift
//  RotaryWheel
//
//  Created by William-Weng on 2018/8/20.
//  Copyright © 2018年 William-Weng. All rights reserved.
//
/// [Drag + Rotation using UIPanGestureRecognizer touch getting off track](https://stackoverflow.com/questions/10181255/drag-rotation-using-uipangesturerecognizer-touch-getting-off-track)

import UIKit

@IBDesignable
class WWRotaryWheel: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var baseView: UIView!
    
    @IBInspectable var backgroundImage: UIColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) { willSet { backgroundColorSetting(with: newValue)}}
    @IBInspectable var count: UInt = 1 { willSet { setNeedsDisplay() }}
    
    let rotationZ = "transform.rotation.z"
    
    var startTransform = CGAffineTransform()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromXib()
        registerGestureRecognizer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromXib()
        registerGestureRecognizer()
    }
    
    override func draw(_ rect: CGRect) {
        buttonsSetting(with: count, rect: rect)
    }
}

// MARK: init
extension WWRotaryWheel {
    
    /// 載入XIB的一些基本設定
    func initViewFromXib() {
        
        let bundle = Bundle.init(for: WWRotaryWheel.self)
        let name = String(describing: WWRotaryWheel.self)
        
        bundle.loadNibNamed(name, owner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
}

// MARK: Selector
extension WWRotaryWheel {
    
    /// 按下按鈕
    @objc func clickButton(_ sender: UIButton) {
        print(sender.tag)
    }
    
    /// 旋轉滾輪
    @objc func rotaryWheel(_ gesture: UIPanGestureRecognizer) {
        
        let state = gesture.state
        let coordinate = gesture.translation(in: baseView)
        let radian = atan2f(Float(coordinate.x), Float(coordinate.y))
        let fixRadian = radian + Float(angleToRadian(with: 90))
        
        switch state {
        case .began:
            startTransform = baseView.transform
        case .changed:
            baseView.transform = startTransform.rotated(by: CGFloat(-1 * fixRadian))
        case .ended:
            break
        case .possible, .cancelled, .failed:
            print(coordinate)
        }
    }
}

/// MARK: 設定
extension WWRotaryWheel {
    
    /// 設定背景顏色
    func backgroundColorSetting(with color: UIColor) {
        baseView.backgroundColor = color
    }
    
    /// 按鈕與背後的移動View的初始化設定 (改變錨點 => 底部對齊 => 對齊中點 => 按照比較旋轉) => (button要比label小，不然按了沒反應)
    func buttonsSetting(with count: UInt, rect: CGRect) {
        
        let anchorPoint = CGPoint(x: 0.5, y: 1.0)
        let labelSize: (width: CGFloat, height: CGFloat) = (36, rotaryAxisMaxHeight(with: rect))
        
        for index in 0..<count {
            
            let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: labelSize.width, height: labelSize.height))
            let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: labelSize.width, height: labelSize.width))
            let angle = 360.0 / Float(count) * Float(index)
            
            label.text = index.description
            label.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            label.center = baseView.center
            label.layer.anchorPoint = anchorPoint
            label.transform = CGAffineTransform.init(rotationAngle: angleToRadian(with: angle))
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            
            button.tag = Int(index)
            button.backgroundColor = .red
            button.setTitle("\(index)", for: .normal)
            button.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
            
            label.addSubview(button)
            baseView.addSubview(label)
        }
    }
    
    /// 動畫測試
    func loadingAnimation() {
        
        let animation = CAKeyframeAnimation()
        let animationKey = "transform.rotation.z"
        
        animation.keyPath = animationKey
        animation.values = [0, Double.pi * 2]
        animation.repeatCount = 5
        animation.duration = 1.0
        
        baseView.layer.add(animation, forKey: animationKey)
    }
    
    /// 註冊GestureRecognizer
    func registerGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(rotaryWheel(_:)))
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.minimumNumberOfTouches = 1
        baseView.addGestureRecognizer(panGestureRecognizer)
    }
}

/// MARK: 小工具
extension WWRotaryWheel {
    
    /// 180 -> π
    func angleToRadian(with angle: Float) -> CGFloat {
        return CGFloat(angle * Float.pi / 180)
    }
    
    /// π -> 180
    func radianToAngle(with radian: Float) -> CGFloat {
        return CGFloat(radian / Float.pi * 180)
    }
    
    /// 轉軸的最大高度
    func rotaryAxisMaxHeight(with rect: CGRect) -> CGFloat {
        let size = rect.size
        return (size.width > size.height) ? (size.height / 2.0) : (size.width / 2.0)
    }
}
