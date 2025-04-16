//
//  DiverListView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/16/25.
//

import SwiftUI

struct DiverListView: View {
    @State private var divers = Diver.builtins + Diver.builtins + Diver.builtins

    var body: some View {
        NavigationStack {
            ZStack {
                Color.C_4
                    .ignoresSafeArea()

                VStack {
                    VStack {
                        ProfileImageView()
                        Text("Main Diver")
                    }
                    .frame(height: 150)
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.C_3)
                            .padding()
                        ScrollView {
                            LazyVGrid(
                                columns: Array(repeating: GridItem(), count: 3)
                            ) {
                                ForEach(divers) { diver in
                                    VStack {
                                        ProfileImageView()
                                            .padding(.bottom, 4)
                                        Text(diver.nickname)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                    }
                                    .padding()
                                }
                            }
                        }
                        .padding()
                        .clipped()
                    }
                }
            }
            .navigationTitle("다이버 도감")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {

                    } label: {
                        Text("편집")
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    DiverListView()
}
