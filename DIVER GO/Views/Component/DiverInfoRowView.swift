//
//  DiverInfoRowView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/15/25.
//

import SwiftUI

struct DiverInfoRowView: View {
    @Binding var diverInfo: DiverInfo
    @State private var isEditing = false
    @State private var tempTitle = ""
    
    var body: some View {
        HStack {
            Text(diverInfo.title)
                .onTapGesture {
                    if !diverInfo.isRequired {
                        tempTitle = diverInfo.title
                        isEditing = true
                    }
                }
            TextField(diverInfo.title, text: $diverInfo.description)
                .multilineTextAlignment(.trailing)
        }
        .alert("제목을 수정하시겠습니까?", isPresented: $isEditing) {
            TextField("제목을 입력하세요.", text: $tempTitle)
            Button("취소", role: .cancel) {
                isEditing = false
            }
            Button("확인") {
                diverInfo.title = tempTitle
            }
            .disabled(tempTitle.isEmpty)
        }
    }
}

#Preview {
    @Previewable @State var diverInfo = DiverInfo(
        title: "관심 분야",
        description: "Tech"
    )
    
    return Form {
        DiverInfoRowView(diverInfo: $diverInfo)
    }
}
