//
//  AuthView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 17.02.2025.
//

import SwiftUI

struct AuthView: View {
    @State var phoneNumber = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack {
                    Rectangle()
                        .frame(height: 170)
                    logo
                    textField($phoneNumber)
                    button
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
    
    func textField(_ text: Binding<String>) -> some View {
        VStack {
            Text("Введите ваш номер телефона")
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.69))
            TextField("Введите ваш номер телефона", text: text,
                      prompt: Text("+_"+"(___)___-__-__")
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
    AuthView()
}
