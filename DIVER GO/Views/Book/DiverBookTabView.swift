//
//  DiverBookTabView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/23/25.
//

import MCEmojiPicker
import MulticolorGradient
import SwiftData
import SwiftUI

struct DiverBookTabView: View {
    let namespace: Namespace.ID
    @Binding var mainDiver: Diver
    @Binding var selectedDiver: Diver?

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Diver.updatedAt, order: .reverse) private var divers: [Diver]
    @State private var isEditing = false

    var body: some View {
        ZStack {
            GradientBackground(color: mainDiver.color.toColor)

            DiverListView(
                namespace: namespace,
                mainDiver: $mainDiver,
                selectedDiver: $selectedDiver
            )

            if divers.count < 2 {
                Text("다른 다이버를 만나볼까요?")
                    .glassOpacity()
            }

            NavigationTitle(
                title: "DIVER GO",
                leading: {
                    MainDiverCard
                },
                trailing: {
                    ShareButton
                }
            )
        }
        .navigationDestination(item: $selectedDiver) { diver in
            DiverCardDetailView(
                diver: diver,
                isEditing: $isEditing,
                isEditAvailable: diver.id == mainDiver.id
            )
            .navigationTransition(
                .zoom(sourceID: diver.id, in: namespace)
            )
            .toolbarVisibility(.hidden)
        }
    }

    private var MainDiverCard: some View {
        Circle()
            .fill(.regularMaterial)
            .frame(width: 32, height: 32)
            .overlay {
                if mainDiver.emoji.isEmpty {
                    Image(.diver)
                        .resizable()
                        .scaledToFit()
                        .padding(8)
                } else {
                    Text(mainDiver.emoji)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                }
            }
            .matchedTransitionSource(
                id: mainDiver.id,
                in: namespace
            )
            .onTapGesture {
                selectedDiver = mainDiver
            }
            .glassShadow()
    }

    private var ShareButton: some View {
        ShareLink(
            item: mainDiver.toURL(),
            preview: SharePreview(
                mainDiver.nickname,
                image: mainDiver.emoji.isEmpty
                    ? Image(.diver)
                    : Image(
                        uiImage: ImageRenderer(
                            content: Text(
                                mainDiver.emoji
                            )
                            .font(.system(size: 1024))

                        ).uiImage!
                    )
            )
        ) {
            Image(systemName: "square.and.arrow.up")
                .foregroundStyle(Color(.label))
                .bold()
                .glassOpacity()
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
        DiverBookTabView(
            namespace: namespace,
            mainDiver: $mainDiver,
            selectedDiver: $selectedDiver
        )
    }
    .modelContainer(container)
}
