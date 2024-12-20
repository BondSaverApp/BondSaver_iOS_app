//
//  ContactEditView.swift
//  KeepLink
//
//  Created by Maria Mayorova on 20.12.2024.
//

import SwiftUI

struct ContactEditView: View {
    @Binding var isShowSheet: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    
                }
            }
            .navigationTitle("Редактировать контакт")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Сохранить"){
                        
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Закрыть") {
                        isShowSheet = false
                    }
                }
            }
        }
    }
}
  
#Preview {
    @Previewable @State var isShowSheet: Bool = true
    ContactEditView(isShowSheet: $isShowSheet)
}
