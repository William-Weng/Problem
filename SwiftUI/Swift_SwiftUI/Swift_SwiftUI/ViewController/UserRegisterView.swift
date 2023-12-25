//
//  UserRegisterView.swift
//  Example
//
//  Created by iOS on 2023/12/25.
//

import SwiftUI
import Combine

class RegistrationSwiftViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var eMail: String = ""
    @Published var password: String = ""

    var canRegister: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest3($username, $eMail, $password)
            .map { username, email, password in
                return !username.isEmpty && !email.isEmpty && !password.isEmpty
            }
            .eraseToAnyPublisher()
    }

    func register() {
        print("Registering user with username: \(username), email: \(eMail), password: \(password)")
    }
}

struct RegistrationView: View {
    
    @ObservedObject var viewModel = RegistrationSwiftViewModel()

    @State private var isRegisterButtonDisabled = true
    private var cancellables: Set<AnyCancellable> = []

    var body: some View {
        
        VStack {
            TextField("Username", text: $viewModel.username)
                .overlay(Divider().offset(x: 0, y: 10).foregroundColor(Color.red), alignment: .bottom)
                .padding()
                .onReceive(viewModel.canRegister) { canRegister in self.isRegisterButtonDisabled = !canRegister }

            TextField("Email", text: $viewModel.eMail)
                .overlay(Divider().offset(x: 0, y: 10), alignment: .bottom)
                .padding()

            SecureField("Password", text: $viewModel.password)
                .overlay(Divider().offset(x: 0, y: 10), alignment: .bottom)
                .padding()

            Button("Register") {
                viewModel.register()
            }
            .buttonStyle(.bordered)
            .tint(.blue)
            .padding()
            .disabled(isRegisterButtonDisabled)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}

class UserRegisterViewHostingController: UIHostingController<RegistrationView> {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: RegistrationView())
    }
}
