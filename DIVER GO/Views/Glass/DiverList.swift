//
//  DiverList.swift
//  DIVER GO
//
//  Created by 정희균 on 4/23/25.
//

import MulticolorGradient
import SwiftUI

struct DiverList: View {
    var namespace: Namespace.ID
    let mainDiver: Diver
    let divers: [Diver]
    @Binding var selectedDiver: Diver?

    var body: some View {
        ZStack {
            MulticolorGradient {
                ColorStop(
                    position: .topLeading,
                    color: mainDiver.color.toColor.mix(with: .red, by: 0.7)
                )
                ColorStop(
                    position: .trailing,
                    color: mainDiver.color.toColor
                )
                ColorStop(
                    position: .bottomLeading,
                    color: mainDiver.color.toColor.mix(with: .blue, by: 0.7)
                )
            }
            .scaleEffect(1.1)
            .opacity(0.5)
            .ignoresSafeArea()

            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
                    ForEach(divers) { diver in
                        //                        NavigationLink {
                        //                            DiverCardDetailView(diver: diver)
                        //                                .navigationTransition(
                        //                                    .zoom(sourceID: diver.id, in: namespace)
                        //                                )
                        //                                .toolbarVisibility(.hidden)
                        //
                        //                        } label: {
                        DiverCardView(diver: diver)
                            .matchedTransitionSource(
                                id: diver.id,
                                in: namespace
                            )
                            .foregroundStyle(Color(.label))
                            .onTapGesture {
                                selectedDiver = diver
                            }
                        //                        }
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
                    Rectangle()
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

            HStack {
                Text("🍋")
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .frame(width: 32, height: 32)
                    .background(.regularMaterial, in: Circle())
                    .matchedTransitionSource(
                        id: mainDiver.id,
                        in: namespace
                    )
                    .glassShadow()
                    .onTapGesture {
                        selectedDiver = mainDiver
                    }
                Spacer()
                ShareLink(
                    item: Diver.builtin.toURL(),
                    preview: SharePreview("DIVER GO")
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
    }
}

#Preview {
    @Previewable @Namespace var namespace

    return NavigationStack {
        DiverList(
            namespace: namespace,
            mainDiver: .builtin,
            divers: Diver.builtins + Diver.builtins + Diver.builtins,
            selectedDiver: .constant(nil)
        )
    }
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
            Text(diver.emoji.isEmpty ? "🍋" : diver.emoji)
                .font(.largeTitle)
                .padding()
                .background(.ultraThickMaterial, in: Circle())
                .padding(.bottom)
            //                                .shadow(color: .C_1.opacity(0.5), radius: 16)

            VStack(alignment: .center) {
                Text(diver.nickname)
                    //                    .font(.headline)
                    .font(.system(.headline, design: .rounded))
                    .opacity(0.7)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                //                                    .padding(.top)
                //                                ScrollView(.horizontal) {
                //
                //                                    LazyHStack {
                //                                        ForEach(diver.infoList) { info in
                //                                            Text("MBTI")
                //                                                .font(.caption)
                //                                                .opacity(0.6)
                //                                                .padding(8)
                //                                                .background(
                //                                                    .thickMaterial,
                //                                                    in: RoundedRectangle(
                //                                                        cornerRadius: 8
                //                                                    )
                //                                                )
                //                                        }
                //                                    }
                //                                }
                //                                .scrollIndicators(.hidden)
                if let mbti = diver.infoList.first(where: { $0.title == "MBTI" }
                ) {
                    Text(mbti.description.isEmpty ? "MBTI" : mbti.description)
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
        //                        .background(
        //                            .ultraThinMaterial,
        //                           in: RoundedRectangle(cornerRadius: 20)
        //                        )
        //                        .background {
        //                            Circle()
        //                                .fill(.C_1)
        //                                .frame(width: 100)
        //                                .offset(x: -20, y: -30)
        //                            Circle()
        //                                .fill(.C_1.opacity(0.5))
        //                                .frame(width: 100)
        //                                .offset(x: 20, y: 30)
        //                        }
        //                        .clipShape(RoundedRectangle(cornerRadius: 20))
        .background {
            VStack(spacing: 0) {
                Circle()
                    .fill(diver.color.toColor)
                    .frame(width: 48)
                    .offset(y: -40)
                //                                Color.clear
            }
            VStack(spacing: 0) {
                Color.clear
                Color(.systemBackground).opacity(0.8)
            }
            Rectangle()
                .fill(.thinMaterial)
            //                .mask {
            //                    LinearGradient(
            //                        colors: [.black, .clear],
            //                        startPoint: .top,
            //                        endPoint: .bottom
            //                    )
            //                }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))

    }
}

struct DiverCardDetailView: View {
    @Bindable var diver: Diver
    let isEditAvailable = true
    let isShowingToolBar = true

    @Environment(\.dismiss) private var dismiss
    @State private var isEditing = true

    var body: some View {
        ZStack {
            //                VStack(spacing: 0) {
            //                    Circle()
            //                        .fill(.green)
            //                        .frame(width: 256)
            //                        .offset(x: -128, y: -256)
            //                    //                                Color.clear
            //                        .blur(radius: 32)
            ////                        .opacity(0.7)
            //                }
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
            .opacity(0.5)
            .ignoresSafeArea()

            ScrollView {
                LazyVStack {
                    Text(diver.emoji.isEmpty ? "🫥" : diver.emoji)
                        .font(.system(size: 128))
                        .padding(32)
                        .background(
                            .thickMaterial,
                            in: Circle()
                        )
                        .glassShadow()
                        .overlay {
                            if isEditing {
                                Button {
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
                                Text(wrappedInfo.title)
                                    .font(.headline)
                                    .glassOpacity()
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
                    }
                    .compositingGroup()
                    .glassShadow()
                }
                .padding()
                .padding(.top, 80)
            }

            if isShowingToolBar {
                HStack {
                    if isEditAvailable {
                        Button {
                            withAnimation {
                                isEditing.toggle()
                            }
                        } label: {
                            Image(systemName: "pencil")
                                .foregroundStyle(.gray)
                                .padding(8)
                                .background(Circle().fill(.regularMaterial))
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
    }
}

#Preview {
    @Previewable @State var diver = Diver.builtin

    return DiverCardDetailView(diver: diver)
}
