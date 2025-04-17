//
//  DiverListView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/16/25.
//

import SwiftUI

struct DiverListView: View {
    @State private var divers = Diver.builtins + Diver.builtins + Diver.builtins
    @State private var selectedDiver: Diver?
    @ObservedObject private var diverStore = DiverStore.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.C_4
                    .ignoresSafeArea()

                VStack {
                    VStack {
                        ProfileImageView()
                        Text(diverStore.mainDiver.nickname)
                            .lineLimit(1, reservesSpace: true)
                    }
                    .frame(height: 150)
                    .onTapGesture {
                        selectedDiver = diverStore.mainDiver
                    }
                    
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
                                    .onTapGesture {
                                        selectedDiver = diver
                                    }
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
            .sheet(item: $selectedDiver) { diver in
                DiverDetailView(
                    diver: diver.id == diverStore.mainDiver.id ? $diverStore
                        .mainDiver : .constant(diver)
                )
            }
        }
    }
}

#Preview {
    DiverListView()
        .preferredColorScheme(.dark)
}
