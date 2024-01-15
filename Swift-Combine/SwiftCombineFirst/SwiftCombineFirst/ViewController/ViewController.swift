//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2023/9/11.
//  ~/Library/Caches/org.swift.swiftpm/

import UIKit
import Combine
import WWPrint

// MARK: - 使用者註冊頁
final class ViewController: UIViewController {
    
    private enum UserTextFieldType: Int {
        case username = 101
        case eMail = 201
        case password = 301
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var eMailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var fakeKeyboardView: UIView!
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!
    
    private var viewModel = RegistrationViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nextViewController = segue.destination as? NextViewController else { return }
        
        view.endEditing(true)
        nextViewController.viewModel = viewModel
        cancellables = []   // 請教一下，如果想把值帶過去，但又不想影響到這一頁的話，綁定的部分是要再跑一次嗎？
    }
    
    deinit {
        wwPrint("deinit => \(Self.self)")
    }
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldShouldReturnAction(with: textField)
    }
}

// MARK: - @objc
private extension ViewController {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        storeInputText(with: textField)
    }
    
    @IBAction private func clearInputValues(_ sender: UIBarButtonItem) {
        clearInputValuesAction()
    }
}

// MARK: - 小工具
private extension ViewController {
    
    /// 初始化設定
    func initSetting() {
        editingChangedSetting()
        viewModelSetting()
        viewModelActionSetting()
        keyboardActionSetting()
    }
    
    /// 初始化設定輸入框有輸入時的動作
    func editingChangedSetting() {
        
        keyboardHeightConstraint.constant = 0
        
        usernameTextField.tag = UserTextFieldType.username.rawValue
        eMailTextField.tag = UserTextFieldType.eMail.rawValue
        passwordTextField.tag = UserTextFieldType.password.rawValue
        
        usernameTextField.delegate = self
        eMailTextField.delegate = self
        passwordTextField.delegate = self

        usernameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        eMailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    /// 把輸入的值存起來 (單向：輸入框輸入文字 -> 存變數 / 正在輸入的注音不算)
    /// - Parameter textField: UITextField
    func storeInputText(with textField: UITextField) {
        
        guard textField.markedTextRange == nil,
              let type = UserTextFieldType(rawValue: textField.tag)
        else {
            return
        }
        
        switch type {
        case .username: viewModel.username = textField.text ?? ""
        case .eMail: viewModel.eMail = textField.text ?? ""
        case .password: viewModel.password = textField.text ?? ""
        }
    }
    
    /// [鍵盤按下Return時的處理 (到下一個輸入框)](https://medium.com/彼得潘的-swift-ios-app-開發教室/44-利用-becomefirstresponder-練習鍵盤的顯示-6336f94f8347)
    /// - Parameter textField: UITextField
    /// - Returns: Bool
    func textFieldShouldReturnAction(with textField: UITextField) -> Bool {
        
        guard let type = UserTextFieldType(rawValue: textField.tag) else { return false }
        
        switch type {
        case .username: eMailTextField.becomeFirstResponder()
        case .eMail: passwordTextField.becomeFirstResponder()
        case .password: textField.resignFirstResponder()
        }
        
        return true
    }
    
    /// 取得鍵盤相關資訊後的相關處理
    /// - Parameter info: Constant.KeyboardInformation
    func keyboardAction(with info: Constant.KeyboardInformation) {
        
        let isHidden = info.beginFrame.origin.y < info.endFrame.origin.y
        let options = UIView.AnimationOptions(rawValue: info.curve)
        keyboardHeightConstraint.constant = isHidden ? 0 : info.endFrame.height
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: info.duration, delay: .zero, options: options) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Combine
private extension ViewController {
    
    /// 清除輸入值 => 同時也會清除輸入框
    func clearInputValuesAction() {
        viewModel.clean()
    }
    
    /// 綁定ViewModel (單向：變數內容改變 -> 輸入框文字改變)
    func viewModelSetting() {
        
        viewModel.$username
            .sink { [weak self] newText in self?.usernameTextField.text = "\(newText)" }
            .onCancel { wwPrint("[onCancel] viewModel.$username") }
            .store(in: &cancellables)
        
        viewModel.$eMail
            .sink { [weak self] newText in self?.eMailTextField.text = "\(newText)" }
            .onCancel { wwPrint("[onCancel] viewModel.$eMail") }
            .store(in: &cancellables)
        
        viewModel.$password
            .sink { [weak self] newText in self?.passwordTextField.text = "\(newText)" }
            .onCancel { wwPrint("[onCancel] viewModel.$password") }
            .store(in: &cancellables)
    }
    
    /// 針對ViewModel數值改變時的處理 (註冊按鈕的顏色變化)
    func viewModelActionSetting() {
        
        viewModel.canRegister.sink { canRegister in
            self.registerButton.isEnabled = canRegister
            self.registerButton.backgroundColor = !canRegister ? .darkGray : .systemRed
        }.onCancel { wwPrint("[onCancel] viewModel.canRegister") }
        .store(in: &cancellables)
    }
    
    /// 鍵盤出現與否的設定功能 (有點像事件通知)
    func keyboardActionSetting() {
                
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { notification in
                return UIDevice._keyboardInformation(notification: notification)
            }.sink { info in
                self.keyboardAction(with: info)
            }.onCancel {
                wwPrint("[onCancel] UIResponder.keyboardWillShowNotification")
            }.store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .compactMap { notification in
                return UIDevice._keyboardInformation(notification: notification)
            }.sink { info in
                self.keyboardAction(with: info)
            }.onCancel {
                wwPrint("[onCancel] UIResponder.keyboardWillHideNotification")
            }.store(in: &cancellables)
    }
}

