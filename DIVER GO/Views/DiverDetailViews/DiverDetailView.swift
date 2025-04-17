//
//  DiverDetailView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/16/25.
//

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
    @Binding var diver: Diver
    @Binding var isEditing: Bool
    var dismiss: () -> Void

    var body: some View {
        List {
            Section {
                ProfileImageView()
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
        }
        .scrollContentBackground(.hidden)
        .toolbar {
            if diver.id == DiverStore.shared.mainDiver.id {
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
    @State private var isAddingNewInfo = false
    @State private var newInfo = DiverInfo()

    init(diver: Binding<Diver>, isEditing: Binding<Bool>) {
        self._diver = diver
        self._isEditing = isEditing
        self.editedDiver = diver.wrappedValue
    }

    var body: some View {
        List {
            Section {
                ProfileImageView()
                    .frame(maxWidth: .infinity, maxHeight: 150)
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
                    diver.nickname = editedDiver.nickname
                    diver.infoList = editedDiver.infoList
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
