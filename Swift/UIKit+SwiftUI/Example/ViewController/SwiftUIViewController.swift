//
//  SwiftUIViewController.swift
//  Example
//
//  Created by William.Weng on 2024/7/1.
//

import UIKit

class BarChartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = self._swiftUIView(rootView: BarChartView(stepsBlock: {
            let values =  (1...7).map { _ in return Int.random(in: 100...1000) }
            return values
        }))
    }
}

class TableViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = self._swiftUIView(rootView: TableView())
    }
}
