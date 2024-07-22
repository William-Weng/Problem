//
//  BeautyfaceSwiftSDKDelegate.swift
//  Example
//
//  Created by iOS on 2024/7/22.
//

import Foundation

// MARK: - BeautyfaceSwiftSDKDelegate
public protocol BeautyfaceSwiftSDKDelegate: NSObject {
    
    /// 畫面上檢測到幾張人臉
    /// - Parameters:
    ///   - sdk: Int
    ///   - count: BeautyfaceSwiftSDK
    func faceCount(sdk: BeautyfaceSwiftSDK, count: Int)
}
