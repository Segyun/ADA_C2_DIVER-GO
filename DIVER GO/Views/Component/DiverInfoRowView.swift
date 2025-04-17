//
//  DiverInfoRowView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/16/25.
//

import SwiftUI

struct DiverInfoRowView: View {
    let diverInfo: DiverInfo
    
    var body: some View {
        HStack {
            Text(diverInfo.title)
            Spacer()
            if diverInfo.description.isEmpty {
                Text(diverInfo.title)
                    .foregroundStyle(.tertiary)
            } else {
                Text(diverInfo.description)
            }
        }
    }
}

#Preview {
    @Previewable @State var diverInfo = DiverInfo(
        title: "관심 분야",
        description: "Tech"
    )
    
    return Form {
        DiverInfoRowView(diverInfo: diverInfo)
    }
    .preferredColorScheme(.dark)
}
