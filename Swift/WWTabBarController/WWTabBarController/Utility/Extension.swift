//
//  Extension.swift
//  Example
//
//  Created by William.Weng on 2024/1/1.
//

import UIKit

// MARK: - UIColr (static function)
extension UIColor {
    
    /// 隨機顏色
    /// - Returns: UIColor
    static func _random() -> UIColor { return UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0)}
}

extension UIBezierPath {
    
    static func _capsule(_ rect: CGRect) -> UIBezierPath {
        
        let path = UIBezierPath()
        let startPoint = CGPoint(x: rect.minX + rect.height * 0.5, y: rect.minY)
        let radius = rect.height * 0.5
        let startAngle = CGFloat(-Double.pi * 0.5)
        let endAngle = CGFloat(Double.pi * 0.5)
        
        path.move(to: startPoint)
        path.addArc(withCenter: CGPoint(x: rect.maxX - rect.height * 0.5, y: rect.midY), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.addArc(withCenter: CGPoint(x: rect.minX + rect.height * 0.5, y: rect.midY), radius: radius, startAngle: endAngle, endAngle: startAngle, clockwise: true)
        path.close()
        
        return path
    }
}
