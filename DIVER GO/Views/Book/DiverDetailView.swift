//
//  DiverDetailView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/26/25.
//

import SwiftUI

struct DiverCardDetailView: View {
    @Bindable var diver: Diver
    @Binding var isEditing: Bool
    var isEditAvailable = false
    var onboardingMode = false

    @Environment(\.dismiss) private var dismiss
    @State private var isShowingEmojiPicker = false
    @State private var isDeletingInfo = false
    @State private var selectedInfoID: UUID?

    var body: some View {
        ZStack {
            if !onboardingMode {
                GradientBackground(color: diver.color.toColor)
            }

            ScrollView {
                LazyVStack {
                    Circle()
                        .fill(.thickMaterial)
                        .frame(width: 200)
                        .overlay {
                            if diver.emoji.isEmpty {
                                Image(.diver)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(32)
                            } else {
                                Text(diver.emoji)
                                    .font(.system(size: 128))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                            }
                        }
                        .glassShadow()
                        .overlay {
                            if isEditing {
                                Button {
                                    dismissKeyboard()
                                    isShowingEmojiPicker = true
                                } label: {
                                    Image(systemName: "pencil.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 48)
                                        .symbolRenderingMode(.multicolor)
                                        .foregroundStyle(diver.color.toColor)
                                }
                                .offset(x: 72, y: 72)
                                .glassShadow()
                            }
                        }
                        .emojiPicker(
                            isPresented: $isShowingEmojiPicker,
                            selectedEmoji: $diver.emoji
                        )

                    TextField("닉네임을 입력해주세요.", text: $diver.nickname)
                        .font(.system(.largeTitle, design: .rounded))
                        .bold()
                        .glassOpacity()
                        .padding(.bottom, 32)
                        .multilineTextAlignment(.center)
                        .disabled(!isEditing)

                    if isEditing {
                        HStack {
                            ForEach(DiverColor.allCases, id: \.self) { color in
                                Circle()
                                    .fill(color.toColor)
                                    .frame(width: 28)
                                    .glassShadow()
                                    .overlay {
                                        if diver.color == color {
                                            Circle()
                                                .fill(.gray)
                                                .opacity(0.5)
                                            Image(systemName: "checkmark")
                                                .foregroundStyle(.white)
                                        }
                                    }
                                    .onTapGesture {
                                        withAnimation {
                                            diver.color = color
                                        }
                                    }
                            }
                        }
                        .padding()
                    }

                    LazyVStack(spacing: 8) {
                        ForEach($diver.infoList) { info in
                            DiverInfoRowView(
                                info: info,
                                isEditing: $isEditing,
                                isDeletingInfo: $isDeletingInfo,
                                selectedInfoID: $selectedInfoID
                            )
                        }
                        .compositingGroup()
                        .glassShadow()
                        if isEditing {
                            Button {
                                withAnimation {
                                    diver.infoList.append(DiverInfo())
                                }
                            } label: {
                                Label("추가하기", systemImage: "plus")
                            }
                            .buttonStyle(
                                SecondaryButtonStyle(color: diver.color.toColor)
                            )
                        }
                    }
                }
                .padding()
                .padding(.top, 80)
                .padding(.bottom, onboardingMode ? 160 : 0)
            }

            if !onboardingMode {
                HStack(spacing: 16) {
                    if isEditAvailable {
                        EditButton
                    }
                    DismissButton()
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topTrailing
                )
                .padding()
            }
        }
        .alert(
            "선택한 정보를 삭제하시겠습니까?",
            isPresented: $isDeletingInfo
        ) {
            Button("삭제", role: .destructive) {
                if let selectedInfoID {
                    withAnimation {
                        diver.infoList.removeAll { info in
                            info.id == selectedInfoID
                        }
                    }
                }
            }
        }
        .onDisappear {
            isEditing = false
        }
    }

    private var EditButton: some View {
        Button {
            withAnimation {
                isEditing.toggle()
            }
        } label: {
            Image(
                systemName: isEditing ? "checkmark" : "pencil"
            )
            .foregroundStyle(isEditing ? .white : .gray)
            .padding(8)
            .background {
                if isEditing {
                    Circle()
                        .fill(.green)
                } else {
                    Circle()
                        .fill(.ultraThickMaterial)
                }
            }
        }
        .glassShadow()
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(
                UIResponder.resignFirstResponder
            ),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

#Preview {
    @Previewable @State var diver = Diver.builtin
    @Previewable @State var isEditing = true

    return DiverCardDetailView(
        diver: diver,
        isEditing: $isEditing,
        isEditAvailable: true
    )
}

struct DiverInfoRowView: View {
    @Binding var info: DiverInfo
    @Binding var isEditing: Bool
    @Binding var isDeletingInfo: Bool
    @Binding var selectedInfoID: UUID?

    var body: some View {
        HStack {
            if isEditing {
                Button {
                    selectedInfoID = info.id
                    isDeletingInfo = true
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundStyle(
                            info.isRequired
                                ? .gray : .red
                        )
                }
                .disabled(info.isRequired)
                .glassOpacity()
            }
            TextField("제목", text: $info.title)
                .font(.headline)
                .glassOpacity()
                .disabled(
                    !isEditing || info.isRequired
                )
            TextField(
                info.title,
                text: $info.description
            )
            .glassOpacity()
            .multilineTextAlignment(.trailing)
            .disabled(!isEditing)
        }
        .padding()
        .background(
            .regularMaterial,
            in: RoundedRectangle(cornerRadius: 20)
        )
    }
}
