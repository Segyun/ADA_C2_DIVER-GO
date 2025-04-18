//
//  DiverListView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/16/25.
//

import SwiftUI

struct DiverListView: View {
    @ObservedObject private var diverStore = DiverStore.shared
    
    @State private var isEditing = false
    @State private var isShowingAlert = false
    @State private var deletingDiver: Diver?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.C_4
                    .ignoresSafeArea()

                VStack {
                    VStack {
                        ProfileImageView(
                            emoji: diverStore.mainDiver.emoji,
                            strokeColor: diverStore
                                .getDiverColor(diverStore.mainDiver)
                        )
                            .padding(.bottom, 4)
                        Text(diverStore.mainDiver.nickname)
                            .font(.headline)
                            .lineLimit(1, reservesSpace: true)
                            .minimumScaleFactor(0.5)
                    }
                    .frame(height: 150)
                    .onTapGesture {
                        diverStore.selectedDiver = diverStore.mainDiver
                    }
                    .padding(.top)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.C_3)
                            .padding()
                        ScrollView {
                            LazyVGrid(
                                columns: Array(repeating: GridItem(), count: 3)
                            ) {
                                ForEach(diverStore.divers) { diver in
                                    VStack {
                                        ZStack {
                                            ProfileImageView(
                                                emoji: diver.emoji,
                                                strokeColor: diverStore
                                                    .getDiverColor(diver)
                                            )
                                            .padding(.bottom, 4)
                                            
                                            if isEditing {
                                                Image(systemName: "minus.circle.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 28)
                                                    .symbolRenderingMode(.multicolor)
                                                    .foregroundStyle(.red)
                                                    .offset(x: -32, y: -32)
                                                    .shadow(radius: 7)
                                            }
                                        }
                                        
                                        Text(diver.nickname)
                                            .lineLimit(1, reservesSpace: true)
                                            .minimumScaleFactor(0.5)
                                    }
                                    .padding()
                                    .onTapGesture {
                                        if isEditing {
                                            deletingDiver = diver
                                            isShowingAlert = true
                                        } else {
                                            diverStore.selectedDiver = diver
                                        }
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
                        isEditing.toggle()
                    } label: {
                        Text(isEditing ? "완료" : "편집")
                    }
                }
            }
            .sheet(item: $diverStore.selectedDiver) { diver in
                DiverDetailView(
                    diver: diver.id == diverStore.mainDiver.id ? $diverStore
                        .mainDiver : .constant(diver)
                )
            }
            .alert(
                    "'\(deletingDiver?.nickname ?? "")'을 삭제하시겠습니까?",
                isPresented: $isShowingAlert) {
                    Button("삭제", role: .destructive) {
                        diverStore.deleteDiver(deletingDiver)
                    }
                }
        }
    }
}

#Preview {
    @Previewable var diverStore = DiverStore.shared
    diverStore.divers = Diver.builtins + Diver.builtins
    diverStore.mainDiver = Diver("Lemon")
    diverStore.mainDiver.emoji = "🍋"
    return DiverListView()
        .preferredColorScheme(.dark)
}
