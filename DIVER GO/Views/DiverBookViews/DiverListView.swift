//
//  DiverListView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/16/25.
//

import SwiftData
import SwiftUI

struct DiverListView: View {
    @Binding var mainDiver: Diver
    @Binding var selectedDiver: Diver?

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Diver.updatedAt) private var divers: [Diver]

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
                            emoji: mainDiver.emoji,
                            strokeColor: mainDiver.getStrokeColor(mainDiver)
                        )
                        .padding(.bottom, 4)
                        Text(mainDiver.nickname)
                            .font(.headline)
                            .lineLimit(1, reservesSpace: true)
                            .minimumScaleFactor(0.5)
                    }
                    .frame(height: 150)
                    .onTapGesture {
                        selectedDiver = mainDiver
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
                                ForEach(divers) { diver in
                                    if diver.id != mainDiver.id {
                                        VStack {
                                            ZStack {
                                                ProfileImageView(
                                                    emoji: diver.emoji,
                                                    strokeColor:
                                                        diver
                                                        .getStrokeColor(
                                                            mainDiver
                                                        )
                                                )
                                                .padding(.bottom, 4)

                                                if isEditing {
                                                    Image(
                                                        systemName:
                                                            "minus.circle.fill"
                                                    )
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 28)
                                                    .symbolRenderingMode(
                                                        .multicolor
                                                    )
                                                    .foregroundStyle(.red)
                                                    .offset(x: -32, y: -32)
                                                    .shadow(radius: 7)
                                                }
                                            }

                                            Text(diver.nickname)
                                                .lineLimit(
                                                    1,
                                                    reservesSpace: true
                                                )
                                                .minimumScaleFactor(0.5)
                                        }
                                        .padding()
                                        .onTapGesture {
                                            if isEditing {
                                                deletingDiver = diver
                                                isShowingAlert = true
                                            } else {
                                                selectedDiver = diver
                                            }
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
            .sheet(item: $selectedDiver) { diver in
                DiverDetailView(
                    mainDiver: $mainDiver,
                    diver: diver.id == mainDiver.id
                        ? $mainDiver : .constant(diver)
                )
            }
            .alert(
                "'\(deletingDiver?.nickname ?? "")'을 삭제하시겠습니까?",
                isPresented: $isShowingAlert
            ) {
                Button("삭제", role: .destructive) {
                    if let deletingDiver {
                        UNUserNotificationCenter
                            .current()
                            .removeDeliveredNotifications(
                                withIdentifiers: [deletingDiver.id.uuidString]
                            )
                        modelContext.delete(deletingDiver)
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var mainDiver = Diver("", isDefaultInfo: true)
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Diver.self, configurations: config)
    container.mainContext.insert(mainDiver)

    for i in 1..<10 {
        let diver = Diver("Test \(i)", isDefaultInfo: true)
        container.mainContext.insert(diver)
    }

    return DiverListView(
        mainDiver: $mainDiver,
        selectedDiver: .constant(nil)
    )
    .preferredColorScheme(.dark)
    .modelContainer(container)
}
