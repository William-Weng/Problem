//
//  WWTabbar.swift
//  Example
//
//  Created by iOS on 2024/2/5.
//

import UIKit
import WWPrint

final class WWTabbarView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromXib()
    }
    
    deinit { wwPrint("\(Self.self) deinit") }
}

// MARK: - 小工具
private extension WWTabbarView {
    
    /// 載入XIB的一些基本設定
    func initViewFromXib() {
        
        let xibName = String(describing: Self.self)
        let bundle = Bundle(for: Self.self)
        
        bundle.loadNibNamed(xibName, owner: self, options: nil)
        view.frame = bounds
        addSubview(view)
    }
}
