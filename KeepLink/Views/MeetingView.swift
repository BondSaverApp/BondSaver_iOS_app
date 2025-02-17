//
//  MeetingView.swift
//  KeepLink
//
//  Created by Maria Mayorova on 15.02.2025.
//

import SwiftUI

struct MeetingView: View {
    
    var date: String
    var state: State
    var toDiscuss: [String] = [
        "Как успехи на стажировки DevOps'ом?",
        "Обсудить технологический стек нашего пет проекта",
        "Предложить новый пет проект"
    ]
    
    enum State: String {
        case planned = "Запланировано"
        case inProgress = "Сейчас"
        case finished = "Встреча закончилась"
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "button.programmable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 12)
                Text(state.rawValue)
            }
            .foregroundColor(stateColor)
            Text(date)
                .font(.headline)
                .foregroundStyle(.primary)
                .padding(.bottom, 6)
            Group {
                ForEach(toDiscuss, id: \.self) { topic in
                    HStack {
                        Image(systemName: "circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 5)
                        Text(topic)
                            .font(.caption2)
                    }
                }
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray, lineWidth: 2)
//                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
        )
  
    }
    
    private var stateColor: Color {
        switch state {
        case .planned:
            return Color.purple
        case .inProgress:
            return Color.mint
        case .finished:
            return Color.black.opacity(0.5)
        }
    }
}

#Preview {
    MeetingView(date: "27 февраля 2025 12.00", state: .inProgress)
}
