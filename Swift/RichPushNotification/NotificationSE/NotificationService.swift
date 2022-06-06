//
//  NotificationService.swift
//  NotificationSE
//
//  Created by William.Weng on 2022/6/5.
//

import UserNotifications

final class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        print("NotificationService")
        
        self.contentHandler = contentHandler
        
        guard let bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent) else { return }
        
        bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
        contentHandler(bestAttemptContent)
        
        guard let userInfo = request.content.userInfo as? [String: Any],
              let imageUrlString = userInfo["image"] as? String,
              let imageUrl = URL(string: imageUrlString)
        else {
            contentHandler(bestAttemptContent); return
        }
        
        contentHandler(bestAttemptContent)
        
        print(imageUrl)
        
    }
    
    override func serviceExtensionTimeWillExpire() {
        
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

    func downloadImage(url: URL, result: @escaping (Result<Data?, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error { result(.failure(error)); return }
            result(.success(data))
        }.resume()
    }
}
