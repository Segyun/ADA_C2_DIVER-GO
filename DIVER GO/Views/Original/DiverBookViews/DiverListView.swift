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

    @State private var searchText = ""
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
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(.tertiary)
                                TextField("검색", text: $searchText)
                            }
                            .padding(8)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.C_4)
                            }
                            .padding([.top, .horizontal])

                            if divers.count == 1 {
                                Text("다이버 도감이 비어있어요.")
                                    .foregroundStyle(.tertiary)
                                    .padding()
                            }

                            DiverGridView(
                                searchText: searchText,
                                mainDiver: $mainDiver,
                                selectedDiver: $selectedDiver,
                                isEditing: $isEditing,
                                isShowingAlert: $isShowingAlert,
                                deletingDiver: $deletingDiver
                            )
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

struct DiverGridView: View {
    @Binding var mainDiver: Diver
    @Binding var selectedDiver: Diver?
    @Binding var isEditing: Bool
    @Binding var isShowingAlert: Bool
    @Binding var deletingDiver: Diver?

    @Query private var divers: [Diver]

    init(
        searchText: String,
        mainDiver: Binding<Diver>,
        selectedDiver: Binding<Diver?>,
        isEditing: Binding<Bool>,
        isShowingAlert: Binding<Bool>,
        deletingDiver: Binding<Diver?>
    ) {
        self._mainDiver = mainDiver
        self._selectedDiver = selectedDiver
        self._isEditing = isEditing
        self._isShowingAlert = isShowingAlert
        self._deletingDiver = deletingDiver

        if searchText.isEmpty {
            self._divers = Query(sort: \Diver.updatedAt)
        } else {
            self._divers = Query(
                filter: #Predicate<Diver> { diver in
                    diver.nickname.localizedStandardContains(searchText)
                },
                sort: \Diver.updatedAt
            )
        }
    }

    var body: some View {
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
}

#Preview {
    @Previewable @State var mainDiver = Diver.builtin
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Diver.self, configurations: config)
    container.mainContext.insert(mainDiver)

    for diver in Diver.builtins {
        container.mainContext.insert(diver)
    }

    return DiverListView(
        mainDiver: $mainDiver,
        selectedDiver: .constant(nil)
    )
    .preferredColorScheme(.dark)
    .modelContainer(container)
}
