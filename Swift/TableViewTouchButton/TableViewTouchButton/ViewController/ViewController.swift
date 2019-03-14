//
//  ViewController.swift
//  OCard_TableView
//
//  Created by William-Weng on 2019/3/13.
//  Copyright © 2019年 William-Weng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var myTableView: UITableView!
    
    private let CellIdentifier = "SpaceCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }

    /// 利用點擊的點去判斷Button有沒有被點到
    @objc private func handleTap(_ tap: UITapGestureRecognizer) {
        
        let location = tap.location(in: myButton)
        let isOK = myButton.point(inside: location, with: nil)
        
        myButton.isHighlighted = isOK
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) else { fatalError() }
        
        switch indexPath.row {
        case 0:
            cell.backgroundColor = .clear
            cell.addGestureRecognizer(firstCellTap())
        default:
            cell.backgroundColor = .blue
        }
        
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var cellHeight: CGFloat = 0
        
        switch indexPath.row {
        case 0:  cellHeight = myView.frame.height - 44.0
        default: cellHeight = 66.0
        }

        return cellHeight
    }
}

// MARK: - 小工具
extension ViewController {
    
    /// 初始化設定
    private func initSetting() {
        myTableView.dataSource = self
        myTableView.delegate = self
    }
    
    /// 第一個Cell的Tap事件
    private func firstCellTap() -> UITapGestureRecognizer {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        
        return tap
    }
}
