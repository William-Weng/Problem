//
//  AppDelegate.swift
//  Example
//
//  Created by William.Weng on 2023/9/11.
//
/// [探討 SwiftUI 中的關鍵屬性包裝器：@State、@Binding、@StateObject、@ObservedObject、@EnvironmentObject 和 @Environment | 肘子的 Swift 記事本](https://fatbobman.com/zh/posts/exploring-key-property-wrappers-in-swiftui/)
/// [iOS Combine 學習參考資源](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/ios-combine-學習參考資源-a0ac24f348d4)
/// [使用 #Preview macro 定義預覽畫面. 透過 Xcode 的 preview 功能，我們可以方便地從 preview… | by 彼得潘的 iOS App Neverland | 彼得潘的 Swift iOS App 開發問題解答集 | Medium](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-preview-macro-定義預覽畫面-ios-17-新功能-bc850b2c11fc)
/// [@StateObject 和 @ObservedObject 的區別和使用 | OneV's Den](https://onevcat.com/2020/06/stateobject/)
/// [SwiftUI view 的生命週期影響 StateObject & State property 儲存的資料 | by 彼得潘的 iOS App Neverland | 彼得潘的 Swift iOS App 開發問題解答集 | Medium](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/swiftui-view-的生命週期影響-stateobject-state-儲存的資料-ffd4982fcece)
/// [Demystify SwiftUI - WWDC21 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2021/10022/)
/// [SwiftUI之id(_)如何標識View - 知乎 (可以加速生成)](https://zhuanlan.zhihu.com/p/150958669)
/// [id(_): Identifying SwiftUI Views - The SwiftUI Lab](https://swiftui-lab.com/swiftui-id/)
/// [Building SwiftUI debugging utilities | Swift by Sundell](https://www.swiftbysundell.com/articles/building-swiftui-debugging-utilities/)
/// [Swift Combine 教學 - Wayne's Talk](https://waynestalk.com/swift-combine/)
/// [RxSwift和Combine的相同點和使用例子-CSDN部落格](https://blog.csdn.net/u013538542/article/details/134426757)
/// [URLSession.DataTaskPublisher - ios.dev](https://lochiwei.gitbook.io/ios/frameworks/combine/publishers/urlsession.datataskpublisher)
/// [Combine實現連續請求 - 簡書](https://www.jianshu.com/p/157978e2f283)
/// [RxSwift和Combine的相同點和使用例子_rxswift combine-CSDN部落格](https://blog.csdn.net/u013538542/article/details/134426757)
/// [Managing self and cancellable references when using Combine | Swift by Sundell](https://www.swiftbysundell.com/articles/combine-self-cancellable-memory-management/)

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}

