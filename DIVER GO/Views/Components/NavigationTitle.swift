//
//  NavigationTitle.swift
//  DIVER GO
//
//  Created by 정희균 on 4/26/25.
//

import SwiftUI

struct NavigationTitle<Leading: View, Trailing: View>: View {
    let title: String
    @ViewBuilder let leading: () -> Leading
    @ViewBuilder let trailing: () -> Trailing

    var body: some View {
        ZStack {
            Text(title)
                .font(.system(.largeTitle, design: .rounded))
                .bold()
                .glassOpacity()
            HStack {
                leading()
                Spacer()
                trailing()
            }
            .padding(.horizontal, 8)
        }
        .padding()
        .padding(.bottom, 32)
        .frame(maxWidth: .infinity)
        .background {
            FadingBackground(gradientDirection: .bottomToTop)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    NavigationTitle(
        title: "Navigation Title",
        leading: {
            Circle()
                .fill(.red)
                .frame(width: 32, height: 32)
        },
        trailing: {
            Circle()
                .fill(.blue)
                .frame(width: 32, height: 32)
        }
    )
}
