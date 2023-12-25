//
//  UserRegisterViewController.swift
//  Example
//
//  Created by William.Weng on 2023/12/25.
//

import UIKit
import Combine

class RegistrationViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var eMail: String = ""
    @Published var password: String = ""

    var canRegister: AnyPublisher<Bool, Never> {
        
        return Publishers.CombineLatest3($username, $eMail, $password)
            .map { username, email, password in return !username.isEmpty && !email.isEmpty && !password.isEmpty }
            .eraseToAnyPublisher()
    }

    func registerAnswear() -> String {
        let answear = "Registering user with username: \(username), email: \(eMail), password: \(password)"
        return answear
    }
}

class UserRegisterViewController: UIViewController {
    
    enum UserTextFieldType: Int {
        case username = 101
        case eMail = 201
        case password = 301
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var eMailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var resultTextView: UITextView!

    private let viewModel = RegistrationViewModel()
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
        initCmbineSetting()
        combineDemo()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        
        guard let type = UserTextFieldType(rawValue: textField.tag) else { return }
        
        switch type {
        case .username: viewModel.username = textField.text ?? ""
        case .eMail: viewModel.eMail = textField.text ?? ""
        case .password: viewModel.password = textField.text ?? ""
        }
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        resultTextView.text = viewModel.registerAnswear()
    }
}

private extension UserRegisterViewController {
    
    func initSetting() {
        usernameTextField.tag = UserTextFieldType.username.rawValue
        eMailTextField.tag = UserTextFieldType.eMail.rawValue
        passwordTextField.tag = UserTextFieldType.password.rawValue
    }
    
    func initCmbineSetting() {
        
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        eMailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func combineDemo() {
        
        viewModel.$username
            .sink { [weak self] newText in self?.usernameTextField.text = "\(newText)" }
            .store(in: &cancellables)
        
        viewModel.$eMail
            .sink { [weak self] newText in self?.eMailTextField.text = "\(newText)" }
            .store(in: &cancellables)
        
        viewModel.$password
            .sink { [weak self] newText in self?.passwordTextField.text = "\(newText)" }
            .store(in: &cancellables)
        
        viewModel.canRegister.sink { [weak self] canRegister in
            self?.registerButton.backgroundColor = (!canRegister) ? .lightGray : .blue
            self?.registerButton.isEnabled = canRegister
            self?.resultTextView.text = ""
        }.store(in: &cancellables)
    }
}

