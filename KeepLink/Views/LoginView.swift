//
//  LoginView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 17.02.2025.
//


import SwiftUI

struct LoginView: View {
    let phoneNumber: String
    @State var password = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    Rectangle()
                        .frame(height: 170)
                    logo
                    phoneNubmerText
                    textField($password)
                    button
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
    
    var phoneNubmerText: some View {
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
    }
    
    var logo: some View {
        VStack(spacing: 0) {
            Image("FlowLink")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            Text("FlowLink")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    LoginView(phoneNumber: "+9(999)999-99-99")
}
