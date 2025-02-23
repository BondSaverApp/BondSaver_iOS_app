//
//  OnboardingView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 17.02.2025.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                background
                VStack {
                    logo
                    button
                    unnecesaryButtons
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
    
    var button: some View {
        NavigationLink {
            AuthView(isLoggedIn: $isLoggedIn)
        } label: {
            Text("Продолжить с номером телефона")
                .font(.system(size: 19, weight: .medium, design: .rounded))
                .foregroundColor(.white)
                .padding()
                .padding(.horizontal, 10)
                .background(.white.opacity(0.11))
                .cornerRadius(23)
                .padding()
        }
    }
    
    var unnecesaryButtons: some View {
        HStack {
            Button("Политика конфиденциальности") {
                
            }
            Spacer()
            Button("Пользовательское соглашение") {
                
            }
        }
        .padding(.horizontal)
        .font(.system(size: 10))
        .foregroundStyle(.white.opacity(0.35))
    }
    
    var background: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            Image("happyMan")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: .infinity, alignment: .top)
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
            Text("Сделаем нетворкинг проще")
                .font(.system(size: 19, weight: .ultraLight, design: .rounded))
                .foregroundStyle(.white)

        }
    }
}

#Preview {
    OnboardingView(isLoggedIn: .constant(false))
}
