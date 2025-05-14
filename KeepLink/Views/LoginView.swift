import SwiftUI

struct LoginView: View {
    var appViewModel: AppViewModel
    @Binding var isLoggedIn: Bool
    let phoneNumber: String
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    Rectangle()
                        .frame(height: 170)
                    logo
                    phoneNumberText
                    textField($viewModel.password)
                    button
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .overlay {
                    if viewModel.isLoading {
                        ProgressView() // Индикатор загрузки
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(2)
                    }
                }
                .alert("Ошибка", isPresented: $viewModel.showError) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(viewModel.errorMessage)
                }
            }
        }
    }

    var phoneNumberText: some View {
        Text(phoneNumber)
            .font(.system(size: 28, weight: .ultraLight))
            .foregroundColor(.white)
            .padding(.bottom, 5)
            .padding(5)
    }

    func textField(_ text: Binding<String>) -> some View {
        VStack {
            Text("С возвращением!\nВведите ваш пароль")
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.69))
            SecureField("············", text: text)
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
                await viewModel.login(with: phoneNumber)
                isLoggedIn = true
            }
        } label: {
            Text("Войти")
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
//    LoginView(isLoggedIn: .constant(false),phoneNumber: "+9(999)999-99-99")
// }
