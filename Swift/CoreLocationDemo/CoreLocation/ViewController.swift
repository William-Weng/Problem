//
//  ViewController.swift
//  DEMO
//
//  Created by William.Weng on 2020/7/31.
//  Copyright © 2020 William.Weng. All rights reserved.
//
/// [獲取定位授權和注意事項](https://www.jianshu.com/p/12e3f54fc0f7)
/// [Swift 使用CoreLocation獲取定位與位置資訊](https://www.itread01.com/content/1549183863.html)
/// [IOS CoreLocation實現系統自帶定位的方法 | 程式前沿](https://codertw.com/ios/325890/)
/// [[2019鐵人賽Day14]老蕭咖啡館-簡易說明Info.plist屬性](https://ithelp.ithome.com.tw/articles/10206444)
/// Xcode 11.4.1 / Swift 5

import UIKit
import CoreLocation

// MARK: - 自定義的Print
public func wwPrint<T>(_ msg: T, file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
    Swift.print("🚩 \((file as NSString).lastPathComponent)：\(line) - \(method) \n\t ✅ \(msg)")
    #endif
}

final class ViewController: UIViewController {
    
    private lazy var locationManager = locationManagerMaker(delegate: self)
    
    private var currentLocationInfomation: LocationInfomation = (nil, false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let status = CLLocationManager.authorizationStatus()
        
        locationServicesAuthorizationStatus(status, manager: locationManager,
                                            alwaysHandler: { wwPrint("alwaysHandler") },
                                            whenInUseHandler: { wwPrint("whenInUseHandler") },
                                            deniedHandler: { wwPrint("deniedHandler") })
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocationInfomation = locationInfomation(with: locations)
        manager.stopUpdatingLocation()
    }
    
    typealias LocationInfomation = (location: CLLocation?, isAvailable: Bool)
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationServicesAuthorizationStatus(status, manager: manager,
                                            alwaysHandler: { wwPrint("alwaysHandler") },
                                            whenInUseHandler: { wwPrint("whenInUseHandler") },
                                            deniedHandler: { wwPrint("deniedHandler") })
    }
}

extension ViewController {
    
    /// 定位授權Manager產生器 => NSLocationWhenInUseUsageDescription + NSLocationAlwaysAndWhenInUseUsageDescription
    func locationManagerMaker(delegate: CLLocationManagerDelegate?, desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest, distanceFilter: CLLocationDistance = 1) -> CLLocationManager {
        
        let locationManager = CLLocationManager()

        locationManager.delegate = delegate
        locationManager.desiredAccuracy = desiredAccuracy
        locationManager.distanceFilter = distanceFilter

        return locationManager
    }
    
    /// 定位授權的各種狀態處理
    func locationServicesAuthorizationStatus(_ status: CLAuthorizationStatus, manager: CLLocationManager, alwaysHandler: @escaping () -> Void, whenInUseHandler: @escaping () -> Void, deniedHandler: @escaping () -> Void) {

        switch status {
        case .notDetermined: requestLocationAuthorization(with: manager, isAlways: false)
        case .authorizedWhenInUse: whenInUseHandler()
        case .authorizedAlways: alwaysHandler()
        case .denied: deniedHandler()
        case .restricted: deniedHandler()
        @unknown default: fatalError()
        }
    }
    
    /// 處理位置的相關資料 (有效位置)
    func locationInfomation(with locations: [CLLocation]) -> LocationInfomation {
        
        guard let location = locations.last,
              let isAvailable = Optional.some(location.horizontalAccuracy > 0)
        else {
            return (nil, false)
        }

        return (location, isAvailable)
    }
    
    /// 詢問是否要開啟定位授權 (Alert) => info.plist(NSLocationAlwaysAndWhenInUseUsageDescription / NSLocationWhenInUseUsageDescription)
    func requestLocationAuthorization(with manager: CLLocationManager, isAlways: Bool = true) {
        if (isAlways) { manager.requestAlwaysAuthorization(); return }
        manager.requestWhenInUseAuthorization()
    }
}
