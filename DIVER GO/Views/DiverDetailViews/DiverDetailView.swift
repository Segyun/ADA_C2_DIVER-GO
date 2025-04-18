//
//  DiverDetailView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/16/25.
//

import MCEmojiPicker
import SwiftUI

struct DiverDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isEditing = false
    @Binding var diver: Diver

    var body: some View {
        NavigationView {
            ZStack {
                Color.C_4
                    .ignoresSafeArea()

                if isEditing == true {
                    DiverDetailEditView(diver: $diver, isEditing: $isEditing)
                } else {
                    DiverDetailReadView(diver: $diver, isEditing: $isEditing) {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @ObservedObject var diverStore = DiverStore.shared

    return DiverDetailView(diver: $diverStore.mainDiver)
        .preferredColorScheme(.dark)
}

struct DiverDetailReadView: View {
    @ObservedObject private var diverStore = DiverStore.shared

    @Binding var diver: Diver
    @Binding var isEditing: Bool
    var dismiss: () -> Void

    var body: some View {
        List {
            Section {
                ProfileImageView(
                    emoji: diver.emoji,
                    strokeColor: diverStore.getDiverColor(diver)
                )
                .frame(maxWidth: .infinity, maxHeight: 150)
            }
            .listRowBackground(Color.clear)

            Section {
                Text(diver.nickname)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .listRowBackground(Color.clear)

            Section {
                ForEach(diver.infoList) { info in
                    DiverInfoRowView(diverInfo: info)
                }
            }
            .listRowBackground(Color.C_3)

            Section {
                VStack {
                    if diver.id == diverStore.mainDiver.id {
                        Text(
                            "마지막으로 업데이트되고 \(diver.updatedAt.lastDays())일 지났어요."
                        )
                        Text(
                            "처음 생성되고 \(diver.createdAt.lastDays())일 지났어요."
                        )
                    } else {
                        Text(
                            "마지막으로 만나고 \(diver.updatedAt.lastDays())일 지났어요."
                        )
                        Text(
                            "처음 만나고 \(diver.createdAt.lastDays())일 지났어요."
                        )
                    }
                }
                .font(.caption)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            }
            .foregroundStyle(.secondary)
            .listRowBackground(Color.clear)
        }
        .scrollContentBackground(.hidden)
        .toolbar {
            if diver.id == diverStore.mainDiver.id {
                ToolbarItem(placement: .primaryAction) {
                    ShareLink(
                        item: diver.toURL(),
                        preview: SharePreview(
                            "\(diver.nickname.isEmpty ? "닉네임을 설정해주세요." : diver.nickname)",
                            image: Image(
                                uiImage: ImageRenderer(
                                    content: Text(
                                        diver.emoji.isEmpty
                                            ? "🤿" : diver.emoji
                                    )
                                    .font(.title)
                                ).uiImage!
                            )
                        )
                    )

                }
                ToolbarItem(placement: .primaryAction) {
                    Button("편집") {
                        isEditing = true
                    }
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("완료") {
                    dismiss()
                }
            }
        }
    }
}

struct DiverDetailEditView: View {
    @Binding var diver: Diver
    @Binding var isEditing: Bool

    @State private var editedDiver: Diver
    @State private var newInfo = DiverInfo()
    @State private var isAddingNewInfo = false
    @State private var isEmojiSelecting = false

    init(diver: Binding<Diver>, isEditing: Binding<Bool>) {
        self._diver = diver
        self._isEditing = isEditing
        self.editedDiver = diver.wrappedValue
    }

    var body: some View {
        List {
            Section {
                ZStack {
                    ProfileImageView(emoji: editedDiver.emoji)
                        .frame(maxWidth: .infinity, maxHeight: 150)

                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .symbolRenderingMode(.multicolor)
                        .foregroundStyle(.C_1)
                        .offset(x: 52, y: 52)
                        .shadow(radius: 7)
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil
                    )
                    isEmojiSelecting = true
                }
                .emojiPicker(
                    isPresented: $isEmojiSelecting,
                    selectedEmoji: $editedDiver.emoji
                )
            }
            .listRowBackground(Color.clear)

            Section {
                TextField("닉네임을 입력해주세요.", text: $editedDiver.nickname)
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            .listRowBackground(Color.C_3)

            Section {
                ForEach($editedDiver.infoList) { info in
                    DiverInfoRowEditView(diverInfo: info)
                        .listRowBackground(Color.C_3)
                }
                Button {
                    newInfo = DiverInfo()
                    isAddingNewInfo = true
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("추가하기")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderless)
            }
            .listRowBackground(Color.C_3)
        }
        .scrollContentBackground(.hidden)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("완료") {
                    diver = editedDiver
                    diver.updatedAt = Date()
                    isEditing = false
                }
                .disabled(editedDiver.nickname.isEmpty)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("취소") {
                    isEditing = false
                }
            }
        }
        .alert("새로운 정보를 추가하시겠습니까?", isPresented: $isAddingNewInfo) {
            TextField("제목", text: $newInfo.title)
            Button("취소", role: .cancel) {
                isAddingNewInfo = false
            }
            Button("추가") {
                isAddingNewInfo = false
                withAnimation {
                    editedDiver.infoList.append(newInfo)
                }
            }
        }
    }
}
