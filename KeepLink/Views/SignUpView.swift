//
//  SignUpView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 17.02.2025.
//

import SwiftUI

struct SignUpView: View {
    @Binding var phoneNumber: String
    @State var password = ""
    @State var passwordAgain = ""
    @State var name = ""
    
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
                    textField(prompt: "+_"+"(___)___-__-__", $phoneNumber)
                    textField(prompt: "Пароль", $password)
                    textField(prompt: "Пароль ещё раз", $passwordAgain)
                    textField(prompt: "Как вас зовут?", $name)
                    button
                }
                .frame(maxHeight: .infinity, alignment: .top)
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
    SignUpView(phoneNumber: .constant("+9(999)999-99-99"))
}
