//
//  AuthView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 17.02.2025.
//

import SwiftUI

struct AuthView: View {
    var appViewModel: AppViewModel
    @Binding var isLoggedIn: Bool
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack {
                    Rectangle()
                        .frame(height: 170)
                    logo
                    textField($viewModel.phoneNumber)
                    button
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .navigationDestination(isPresented: Binding<Bool>(
                get: { viewModel.isAccountExists == true },
                set: { _ in }
            )) {
                LoginView(appViewModel: appViewModel,
                          isLoggedIn: $isLoggedIn,
                          phoneNumber: viewModel.phoneNumber,
                          viewModel: appViewModel.loginViewModel) // Переход на LoginView, если isAccountExists == true
            }
            .navigationDestination(isPresented: Binding<Bool>(
                get: { viewModel.isAccountExists == false },
                set: { _ in }
            )) {
                SignUpView(appViewModel: appViewModel,
                           isLoggedIn: $isLoggedIn,
                           phoneNumber: $viewModel.phoneNumber,
                           viewModel: appViewModel.signUpViewModel) // Переход на SignUpView, если isAccountExists == false
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView() // Индикатор загрузки
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2)
                        .opacity(0.5)
                }
            }
        }
    }

    func textField(_ text: Binding<String>) -> some View {
        VStack {
            Text("Введите ваш номер телефона")
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.69))
            TextField("Введите ваш номер телефона", text: text,
                      prompt: Text("+_" + "(___)___-__-__")
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
                .padding()
        }
        .foregroundStyle(.white)
    }

    var button: some View {
        Button {
            Task {
                viewModel.isLoading = true // Показываем индикатор загрузки
                viewModel.checkAccountExists()
                viewModel.isLoading = false // Скрываем индикатор загрузки
            }
        } label: {
            Text("Продолжить")
                .font(.system(size: 19, weight: .medium, design: .rounded))
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.white)
                .cornerRadius(23)
                .padding()
        }
        .disabled(viewModel.isLoading) // Блокируем кнопку во время загрузки
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

// #Preview {
//    AuthView(isLoggedIn: .constant(false))
// }
