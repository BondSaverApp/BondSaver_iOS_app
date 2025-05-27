//
//  SignUpView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 17.02.2025.
//

import SwiftUI

struct SignUpView: View {
    var appViewModel: AppViewModel
    @Binding var isLoggedIn: Bool
    @Binding var email: String
    @ObservedObject var viewModel: SignUpViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack {
                    Rectangle()
                        .frame(height: 170)
                    logo
                    Text("Давайте знакомиться!")
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.69))
                    textField(prompt: "_____________@____.__", $email)
                    textField(prompt: "Пароль", $viewModel.password)
                    textField(prompt: "Пароль ещё раз", $viewModel.passwordAgain)
                    textField(prompt: "Как вас зовут?", $viewModel.username)
                    button
                }
                .scaledToFill()
                .frame(maxHeight: .infinity, alignment: .top)
                .offset(y: -20)
                .overlay {
                    if viewModel.isLoading {
                        ProgressView() // Индикатор загрузки
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(2)
                    }
                }
                .alert("Ошибка", isPresented: $viewModel.showError) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(viewModel.errorMessage)
                }
            }
        }
    }
    
    func textField(prompt: String, _ text: Binding<String>) -> some View {
        VStack {
            TextField(prompt, text: text,
                      prompt: Text(prompt)
                .foregroundColor(.white.opacity(0.15)))
            .font(.system(size: 32, weight: .light))
            .foregroundStyle(.white)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1)
                    .fill(Color(.systemGray4))
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white.opacity(0.1))
                    }
            }
            .frame(width: 320)
            .padding(.top)
        }
        .foregroundStyle(.white)
    }
    
    var button: some View {
        Button {
            Task {
                viewModel.createAccount(with: email)
                isLoggedIn = true
            }
        } label: {
            Text("Создать аккаунт")
                .font(.system(size: 19, weight: .medium, design: .rounded))
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.white)
                .cornerRadius(23)
                .padding()
        }
    }
    
    var logo: some View {
        VStack(spacing: 0) {
            Image("flowlink")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            Text("flowlink")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
        }
    }
}

//#Preview {
//    SignUpView(isLoggedIn: .constant(false), phoneNumber: .constant("+9(999)999-99-99"))
//}
