//
//  DiverList.swift
//  DIVER GO
//
//  Created by 정희균 on 4/23/25.
//

import MCEmojiPicker
import MulticolorGradient
import SwiftData
import SwiftUI

struct DiverList: View {
    let namespace: Namespace.ID
    @Binding var mainDiver: Diver
    @Binding var selectedDiver: Diver?

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Diver.nickname) private var divers: [Diver]
    @State private var isEditing = false

    var body: some View {
        ZStack {
            GradientBackgroundView(diver: mainDiver)

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
                                                diver.id.uuidString
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
                .padding(.top, 64)
                .padding(.bottom, 64)
            }

            Text("DIVER GO")
                .font(.system(.largeTitle, design: .rounded))
                .bold()
                .glassOpacity()
                .padding(.bottom, 32)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: 152,
                    alignment: .bottom
                )
                .background {
                    UnevenRoundedRectangle(
                        topLeadingRadius: 30,
                        topTrailingRadius: 30
                    )
                    .fill(.ultraThinMaterial)
                    .mask {
                        LinearGradient(
                            stops: [
                                .init(color: .black, location: 0),
                                .init(color: .black, location: 0.7),
                                .init(color: .clear, location: 1),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                }
                .ignoresSafeArea(.container)
                .frame(maxHeight: .infinity, alignment: .top)

            if divers.isEmpty {
                Text("다른 다이버를 만나볼까요?")
                    .glassOpacity()
            }

            HStack {
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
                Spacer()
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
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .top
            )
            .padding(24)
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
}

#Preview {
    @Previewable @Namespace var namespace
    @Previewable @State var mainDiver = Diver.builtin
    @Previewable @State var selectedDiver: Diver?

    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Diver.self, configurations: config)

    //    for diver in Diver.builtins {
    //        container.mainContext.insert(diver)
    //    }

    return NavigationStack {
        DiverList(
            namespace: namespace,
            mainDiver: $mainDiver,
            selectedDiver: $selectedDiver
        )
    }
    .modelContainer(container)
}

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xff) / 255
        let green = Double((hex >> 8) & 0xff) / 255
        let blue = Double((hex >> 0) & 0xff) / 255

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

struct GlassShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .black.opacity(0.1), radius: 8)
    }
}

struct GlassOpacity: ViewModifier {
    func body(content: Content) -> some View {
        content
            .opacity(0.7)
    }
}

extension View {
    func glassShadow() -> some View {
        modifier(GlassShadow())
    }

    func glassOpacity() -> some View {
        modifier(GlassOpacity())
    }
}

struct DiverCardView: View {
    let diver: Diver

    var body: some View {
        VStack {
            Circle()
                .fill(.ultraThickMaterial)
                .frame(width: 72)
                .overlay {
                    if diver.emoji.isEmpty {
                        Image(.diver)
                            .resizable()
                            .scaledToFit()
                            .padding()
                    } else {
                        Text(diver.emoji)
                            .font(.system(size: 32))
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                    }
                }

            VStack(alignment: .center) {
                Text(diver.nickname)
                    .font(.system(.headline, design: .rounded))
                    .opacity(0.7)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                if let session = diver.infoList.first(where: {
                    $0.title == "세션"
                }
                ) {
                    Text(
                        session.description.isEmpty ? "세션" : session.description
                    )
                    .font(.caption)
                    .opacity(0.6)
                    .padding(8)
                    .background(
                        .thickMaterial,
                        in: RoundedRectangle(
                            cornerRadius: 8
                        )
                    )
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            VStack(spacing: 0) {
                Circle()
                    .fill(diver.color.toColor)
                    .frame(width: 48)
                    .offset(y: -40)
            }
            VStack(spacing: 0) {
                Color.clear
                Color(.systemBackground).opacity(0.8)
            }
            Rectangle()
                .fill(.thinMaterial)
        }
        //        .clipShape(RoundedRectangle(cornerRadius: 20))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

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
                GradientBackgroundView(diver: diver)
            }

            ScrollView {
                LazyVStack {
                    Circle()
                        .fill(.regularMaterial)
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
                                    UIApplication.shared.sendAction(
                                        #selector(
                                            UIResponder.resignFirstResponder
                                        ),
                                        to: nil,
                                        from: nil,
                                        for: nil
                                    )
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
                            ForEach(Colors.allCases, id: \.self) { color in
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
                            let wrappedInfo = info.wrappedValue
                            HStack {
                                if isEditing {
                                    Button {
                                        selectedInfoID = info.id
                                        isDeletingInfo = true
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundStyle(
                                                wrappedInfo.isRequired
                                                    ? .gray : .red
                                            )
                                    }
                                    .disabled(wrappedInfo.isRequired)
                                    .glassOpacity()
                                }
                                TextField(wrappedInfo.title, text: info.title)
                                    .font(.headline)
                                    .glassOpacity()
                                    .disabled(
                                        !isEditing || wrappedInfo.isRequired
                                    )
                                Spacer()
                                TextField(
                                    wrappedInfo.title,
                                    text: info.description
                                )
                                .multilineTextAlignment(.trailing)
                                .disabled(!isEditing)
                            }
                            .padding()
                            .background(
                                .regularMaterial,
                                in: RoundedRectangle(cornerRadius: 20)
                            )
                        }
                        if isEditing {
                            Button {
                                withAnimation {
                                    diver.infoList.append(DiverInfo("제목"))
                                }
                            } label: {
                                Label("추가하기", systemImage: "plus")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .foregroundStyle(diver.color.toColor)
                                    .glassOpacity()
                                    .padding()
                                    .background(
                                        .regularMaterial,
                                        in: RoundedRectangle(cornerRadius: 20)
                                    )
                            }
                        }
                    }
                    .compositingGroup()
                    .glassShadow()
                }
                .padding()
                .padding(.top, 80)
                .padding(.bottom, onboardingMode ? 80 : 0)
            }

            if !onboardingMode {
                HStack {
                    if isEditAvailable {
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
                                        .fill(.regularMaterial)
                                }
                            }
                        }
                        .glassShadow()
                    }

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.gray)
                            .padding(8)
                            .background(Circle().fill(.regularMaterial))
                            .glassShadow()
                    }
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
}

#Preview {
    @Previewable @State var diver = Diver.builtin
    @Previewable @State var isEditing = false

    return DiverCardDetailView(
        diver: diver,
        isEditing: $isEditing
    )
}

struct GradientBackgroundView: View {
    let diver: Diver

    var body: some View {
        MulticolorGradient {
            ColorStop(
                position: .topLeading,
                color: diver.color.toColor.mix(with: .red, by: 0.7)
            )
            ColorStop(
                position: .trailing,
                color: diver.color.toColor
            )
            ColorStop(
                position: .bottomLeading,
                color: diver.color.toColor.mix(with: .blue, by: 0.7)
            )
        }
        .scaleEffect(1.1)
        .opacity(0.5)
        .ignoresSafeArea()
    }
}
