//
//  WWTabBar.swift
//  Example
//
//  Created by iOS on 2024/2/5.
//

import UIKit

final class WWTabBar: UITabBar {
    
    @IBInspectable var height: Double = 64
    
    override public func sizeThatFits(_ size: CGSize) -> CGSize {

        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = height

        return sizeThatFits
    }
}
