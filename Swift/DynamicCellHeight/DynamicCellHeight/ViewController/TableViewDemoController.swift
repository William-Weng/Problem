//
//  TableViewDemoController.swift
//  Example
//
//  Created by William.Weng on 2023/9/11.
//

import UIKit
import WWPrint

final class TableViewDemoController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    private var count = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView._registerNibCell(with: TableViewCell.self)
        myTableView.delegate = self
        myTableView.dataSource = self
    }
}

extension TableViewDemoController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView._reusableCell(at: indexPath) as TableViewCell
        cell.configure(with: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TableViewCell.exchangeExpandState(tableView, indexPath: indexPath, isSingle: true)
    }
}
