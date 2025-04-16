//
//  ProfileImageView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/15/25.
//

import SwiftUI

struct ProfileImageView: View {
    let strokeColor: Color = .C_1
    
    var body: some View {
        Circle()
            .fill(.gray)
            .stroke(strokeColor, lineWidth: 5)
    }
}

#Preview {
    ProfileImageView()
}
