//
//  MyCollectionReusableHeader.swift
//  Example
//
//  Created by William.Weng on 2021/11/11.
//

import UIKit
import WWPrint

final class ReusableHeader: UICollectionReusableView, CellReusable, NibOwnerLoadable {
    
    @IBOutlet weak var myLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromXib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with indexPath: IndexPath) {
        backgroundColor = .lightGray
        myLabel.text = "細項\(indexPath.section + 1)"
    }
}
