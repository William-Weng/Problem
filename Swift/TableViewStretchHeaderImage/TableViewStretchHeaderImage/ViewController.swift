//
//  ViewController.swift
//  TableViewStretchHeaderImage
//
//  Created by William-Weng on 2018/10/31.
//  Copyright © 2018年 William-Weng. All rights reserved.
//
/// [iOS tableView實現下拉圖片放大效果](https://www.jb51.net/article/139744.htm)
/// [iOS開發-tableView頂部圖片拉伸](https://blog.csdn.net/mickeyYB_520/article/details/50739447)
/// [iOS-tableview頂部拉伸效果(頭像拉伸)](https://blog.csdn.net/qxuewei/article/details/50956252)
/// [iOS tableView實現頂部圖片拉伸效果](https://www.itread01.com/article/1525765015.html)

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    let Top: CGFloat = 200.0
    let ImageViewTag = 1000
    let ChangeColorPersent: CGFloat = 0.60
    
    var barImageView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBarSetting()
        tableViewSetting()
        headerViewSetting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 12, *) { scrollViewDidScroll(myTableView) }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") else { return UITableViewCell() }
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerViewSetting(for: scrollView)
        navigationBarAlpha(for: scrollView)
    }
}

// MARK: - 小工具
extension ViewController {
    
    /// TableView設定
    private func tableViewSetting() {
        automaticallyAdjustsScrollViewInsets = false
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    /// 設定NavigationBar
    private func navigationBarSetting() {
        navigationController?.navigationBar.barTintColor = .orange
        barImageView = navigationController?.navigationBar.subviews.first
    }
    
    /// 做一個高度為200的ImageView貼在上面(-200, 0)，然後再把TableView往下拉到 (0, 0) -> (200, 0)，讓ImageView變成 (-200, 0) -> (0, 0)
    private func headerViewSetting() {
        
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: -Top, width: UIScreen.main.bounds.size.width, height: Top))
        
        imageView.tag = ImageViewTag
        imageView.image = #imageLiteral(resourceName: "iPhone")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        myTableView.contentInset = UIEdgeInsets(top: Top, left: 0, bottom: 0, right: 0)
        myTableView.addSubview(imageView)
    }
    
    /// 當捲動的高度超過200時，就開始更動header的frame
    private func headerViewSetting(for scrollView: UIScrollView) {
        
        let offSet = scrollView.contentOffset.y
        
        guard let imageView = view.viewWithTag(ImageViewTag),
              offSet < -Top
        else {
            return
        }
        
        var frame = imageView.frame
        
        frame.origin.y = offSet
        frame.size.height = -offSet
        imageView.frame = frame
    }
    
    /// 設定NavigationBar的透明度 (以header的高度為基準)
    private func navigationBarAlpha(for scrollView: UIScrollView) {
        
        let delta = CGFloat.maximum(scrollView.contentOffset.y / CGFloat(Top) + 1, 0.00)
        let alpha = CGFloat.minimum(delta, 1.00)
        
        barImageView?.alpha = alpha
        titleSetting(with: alpha)
    }
    
    /// 設定NavigationBarTitle的文字
    private func titleSetting(with alpha: CGFloat) {
        if (alpha > ChangeColorPersent) { titleTextAttributesSetting(with: "iPhoneXs好貴啊…", color: .blue); return }
        titleTextAttributesSetting(with: "要買嗎？", color: .red)
    }
    
    /// 設定字體顏色、大小
    private func titleTextAttributesSetting(with title: String, color: UIColor) {
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: UIFont.boldSystemFont(ofSize: 32.0)
        ]
        
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = title
    }
}
