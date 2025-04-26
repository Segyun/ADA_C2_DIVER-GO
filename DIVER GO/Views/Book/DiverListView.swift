//
//  DiverListView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/26/25.
//

import SwiftUI
import SwiftData

struct DiverListView: View {
    
    let namespace: Namespace.ID
    @Binding var mainDiver: Diver
    @Binding var selectedDiver: Diver?

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Diver.updatedAt, order: .reverse) private var divers: [Diver]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
                ForEach(divers.filter { $0.id != mainDiver.id }) { diver in
                    DiverCardView(diver: diver)
                        .matchedTransitionSource(
                            id: diver.id,
                            in: namespace
                        )
                        .foregroundStyle(Color(.label))
                        .onTapGesture {
                            selectedDiver = diver
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                UNUserNotificationCenter
                                    .current()
                                    .removeDeliveredNotifications(
                                        withIdentifiers: [
                                            diver.id.uuidString,
                                        ]
                                    )
                                modelContext.delete(diver)
                            } label: {
                                Label("삭제하기", systemImage: "trash")
                            }
                        }
                }
            }
            .compositingGroup()
            .shadow(color: .gray.opacity(0.2), radius: 8)
            .padding()
            .padding(.top, 80)
            .padding(.bottom, 80)
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    @Previewable @State var mainDiver = Diver.builtin
    @Previewable @State var selectedDiver: Diver?

    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Diver.self, configurations: config)

    for diver in Diver.builtins {
        container.mainContext.insert(diver)
    }

    return NavigationStack {
        DiverListView(
            namespace: namespace,
            mainDiver: $mainDiver,
            selectedDiver: $selectedDiver
        )
    }
    .modelContainer(container)
}
