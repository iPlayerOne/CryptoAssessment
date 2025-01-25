//
//  LoginView.swift
//  CryptoAssessment
//
//  Created by ikorobov on 25.12.24..
//

import SwiftUI

struct LoginView: View {
    @StateObject private var vm: LoginViewModel
    @State private var showHint: Bool = false
    
    init(container: AppContainer) {
        _vm = StateObject(wrappedValue: container.makeLoginViewModel())
    }
    
    var body: some View {
        VStack {
            AuthTextField(
                title: "Username",
                text:  $vm.username,
                isSecure: false,
                hasError: vm.errorMessage != nil
            )
            
            AuthTextField(title: "Password",
                          text: $vm.password,
                          isSecure: true,
                          hasError: vm.errorMessage != nil
            )
            .padding(.bottom, 20)
            
            if let errorMessage = vm.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(Color.red)
                    .font(.caption)
                    .padding(.bottom, 20)
            }
                
                ButtonView(title: "Login",
                           action: vm.login,
                           backgroundColor: .blue,
                           textColor: .white,
                           isEnabled: !vm.username.isEmpty && !vm.password.isEmpty
                )
                .frame(width: 200)

  
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showHint = true }) {
                    Image(systemName: "questionmark.circle")
                        .font(.title2)
                        .padding()
                }
                .alert("Hint", isPresented: $showHint) {
                    Button("OK", role: .cancel) { showHint = false }
                } message: { Text("Username: qwerty\nPassword: qwerty") }
                
            }
        }
        .padding()
        .onAppear { vm.resetState() }
    }
}

#Preview {
    let container = AppContainer()
    let vm = container.makeLoginViewModel()
        LoginView(container: container)
}
