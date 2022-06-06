//
//  NotificationViewController.swift
//  NotificationCE
//
//  Created by William.Weng on 2022/6/5.
//

import UIKit
import UserNotifications
import UserNotificationsUI

final class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    @IBOutlet weak var myImageView: UIImageView!
    
    override func viewDidLoad() { super.viewDidLoad() }
    
    func didReceive(_ notification: UNNotification) { notificationAction(notification) }
}

// MARK: - 小工具
private extension NotificationViewController {
    
    /// 推播新型的視窗被拉開時的動作
    /// - Parameter notification: UNNotification
    func notificationAction(_ notification: UNNotification) {
        
        guard let userInfo = notification.request.content.userInfo as? [String: Any] ,
              let imageUrlString = userInfo["image"] as? String,
              let imageUrl = URL(string: imageUrlString)
        else {
            return
        }
        
        self.downloadImage(url: imageUrl) { result in
            
            switch result {
            case .failure(let error): print(error)
            case .success(let data):
                
                guard let data = data,
                      let image = UIImage(data: data)
                else {
                    return
                }
                
                DispatchQueue.main.async { self.myImageView.image = image }
            }
        }
    }
    
    /// 下載圖片
    /// - Parameters:
    ///   - url: URL
    ///   - result: Result<Data?, Error>
    func downloadImage(url: URL, result: @escaping (Result<Data?, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error { result(.failure(error)); return }
            result(.success(data))
        }.resume()
    }
}
