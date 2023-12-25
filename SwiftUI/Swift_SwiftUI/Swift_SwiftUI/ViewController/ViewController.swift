//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2023/9/11.
//  ~/Library/Caches/org.swift.swiftpm/
/// [探討 SwiftUI 中的關鍵屬性包裝器：@State、@Binding、@StateObject、@ObservedObject、@EnvironmentObject 和 @Environment | 肘子的 Swift 記事本](https://fatbobman.com/zh/posts/exploring-key-property-wrappers-in-swiftui/)
/// [iOS Combine 學習參考資源](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/ios-combine-學習參考資源-a0ac24f348d4)
/// [使用 #Preview macro 定義預覽畫面. 透過 Xcode 的 preview 功能，我們可以方便地從 preview… | by 彼得潘的 iOS App Neverland | 彼得潘的 Swift iOS App 開發問題解答集 | Medium](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-preview-macro-定義預覽畫面-ios-17-新功能-bc850b2c11fc)
/// [@StateObject 和 @ObservedObject 的區別和使用 | OneV's Den](https://onevcat.com/2020/06/stateobject/)

import UIKit
import Combine

class TextChangePublisher: ObservableObject {
    @Published var text: String = ""
}

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    private let textChangePublisher = TextChangePublisher()
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        textChangePublisher.$text
            .sink { [weak self] newText in self?.label.text = "輸入的文字: \(newText)" }
            .store(in: &cancellables)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        textChangePublisher.text = textField.text ?? ""
    }
}
