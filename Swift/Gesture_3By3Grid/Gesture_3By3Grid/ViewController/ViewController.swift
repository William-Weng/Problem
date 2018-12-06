//
//  ViewController.swift
//  Gesture_3By3Grid
//
//  Created by William-Weng on 2018/12/5.
//  Copyright © 2018年 William-Weng. All rights reserved.
//
/// [UIBezierPath 的基本使用方法](http://furnacedigital.blogspot.tw/2011/07/uibezierpath.html)

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myGridView: MyGridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class MyGridView: UIView {
    
    var nowIndex = 0
    var gridButtons = [UIButton]()
    var linePoint: (first: CGPoint?, next: CGPoint?) = (nil, nil)
    var result = [UIButton]()
    var lineView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initGridButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initGridButtons()
    }
    
    override func draw(_ rect: CGRect) {
        drawLine()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first,
              let position = Optional.some(touch.location(in: self)),
              let button = touchedButton(withPosition: position)
        else {
            return
        }
        
        button.isSelected = true
        linePoint.first = button.center
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let _ = linePoint.first,
              let touch = touches.first,
              let position = Optional.some(touch.location(in: self))
        else {
            return
        }
        
        _ = touchedButton(withPosition: position)

        linePoint.next = position
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        linePoint = (nil, nil)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
}

extension MyGridView {
    
    /// 加上按鈕
    private func initGridButtons() {
        
        let buttonSize = CGSize(width: 80, height: 80)
        
        for xIndex in 1...3 {
            
            for yIndex in 1...3 {
                
                let button = UIButton()
                let buttonOrigin = CGPoint(x: CGFloat(xIndex - 1) * buttonSize.width , y: CGFloat(yIndex - 1) * buttonSize.height)
                
                button.tag = xIndex * yIndex
                button.frame = CGRect(origin: buttonOrigin, size: buttonSize)
                button.setImage(#imageLiteral(resourceName: "TouchNormal"), for: .normal)
                button.setImage(#imageLiteral(resourceName: "TouchSelected"), for: .selected)
                button.backgroundColor = .clear
                button.isUserInteractionEnabled = false
                
                gridButtons.append(button)
                addSubview(button)
            }
        }
    }
    
    /// 畫線
    private func drawLine() {
        
        guard let firstLinePoint = linePoint.first,
              let nextLinePoint = linePoint.next
        else {
            return
        }
        
        UIColor(red: 32/255.0, green: 210/255.0, blue: 254/255.0, alpha: 0.5).set()
        
        let bezierPath = UIBezierPath()
        
        bezierPath.lineWidth = 8
        bezierPath.lineJoinStyle = .round
        
        bezierPath.move(to: firstLinePoint)
        bezierPath.addLine(to: nextLinePoint)
        bezierPath.close()
        bezierPath.stroke()
    }
    
    /// 測試有沒有碰到?
    private func touchedButton(withPosition position: CGPoint) -> UIButton? {
        
        var touchedButton: UIButton?
        
        for button in gridButtons {
            
            if (button.frame.contains(position)) {
                button.isSelected = true
                touchedButton = button; break
            }
        }
        
        return touchedButton
    }
}
