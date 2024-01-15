//
//  ViewModel.swift
//  SwiftCombineFirst
//
//  Created by iOS on 2024/1/15.
//

import UIKit
import Combine

// MARK: - ViewModel
final class RegistrationViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var eMail: String = ""
    @Published var password: String = ""

    var canRegister: AnyPublisher<Bool, Never> { return canRegisterRule() }
}

// MARK: - 小工具
extension RegistrationViewModel {
    
    /// 清除
    func clean() {
        username = ""
        eMail = ""
        password = ""
    }
}

// MARK: - 小工具
private extension RegistrationViewModel {
    
    /// 可以註冊的規則 (通通要有值)
    /// - Returns: AnyPublisher<Bool, Never>
    func canRegisterRule() -> AnyPublisher<Bool, Never> {
        
        let rule = Publishers.CombineLatest3($username, $eMail, $password)
            .map { username, email, password in return !username.isEmpty && !email.isEmpty && !password.isEmpty }
            .eraseToAnyPublisher()

        return rule
    }
}
