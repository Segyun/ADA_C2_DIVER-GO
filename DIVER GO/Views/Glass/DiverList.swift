//
//  DiverList.swift
//  DIVER GO
//
//  Created by 정희균 on 4/23/25.
//

import MulticolorGradient
import SwiftUI

struct DiverList: View {
    @Namespace private var namespace
    let divers: [Diver]
    var body: some View {
        NavigationStack {
            ZStack {
                //                        LinearGradient(
                //                            colors: [.C_1, .C_4],
                //                            startPoint: .top,
                //                            endPoint: .bottom
                //                        )
                //            .ignoresSafeArea()
                //                Color(hex: 0x8d99ae)
                //                    .clipShape(RoundedRectangle(cornerRadius: 48))
                //                    .ignoresSafeArea()

                MulticolorGradient {
                    ColorStop(position: .topLeading, color: .C_1)
                    ColorStop(position: .trailing, color: .red)
                    ColorStop(position: .bottomTrailing, color: .C_2)
                }
                .opacity(0.5)
                .ignoresSafeArea()

                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
                        ForEach(divers) { diver in
                            NavigationLink {
                                DiverCardDetailView(diver: .constant(diver))
                                    .navigationTransition(
                                        .zoom(sourceID: diver.id, in: namespace)
                                    )
                                    .toolbarVisibility(.hidden)

                            } label: {
                                DiverCardView(diver: diver)
                                    .matchedTransitionSource(
                                        id: diver.id,
                                        in: namespace
                                    )
                                    .foregroundStyle(Color(.label))
                            }
                        }

                    }
                    .compositingGroup()
                    .shadow(color: .gray.opacity(0.2), radius: 8)
                    .padding()
                    .padding(.top, 64)
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
                    .background(.ultraThinMaterial)
                    .mask {
                        LinearGradient(
                            stops: [
                                .init(color: .black, location: 0),
                                .init(color: .black, location: 0.8),
                                .init(color: .clear, location: 1),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                    .ignoresSafeArea(.container)
                    .frame(maxHeight: .infinity, alignment: .top)

                HStack {
                    let diver = Diver.builtin
                    NavigationLink {
                        DiverCardDetailView(diver: .constant(diver))
                            .navigationTransition(
                                .zoom(sourceID: diver.id, in: namespace)
                            )
                            .toolbarVisibility(.hidden)

                    } label: {
                        Text("🍋")
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                            .frame(width: 32, height: 32)
                            .background(.regularMaterial, in: Circle())
                            .matchedTransitionSource(
                                id: diver.id,
                                in: namespace
                            )
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
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DiverList(divers: Diver.builtins + Diver.builtins + Diver.builtins)
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
            .shadow(color: .gray.opacity(0.2), radius: 8)
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
                Text("INFJ")
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
    @Binding var diver: Diver

    @Environment(\.dismiss) private var dismiss

    let isEditAvailable = true

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
                        .shadow(color: .gray.opacity(0.2), radius: 8)
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
                                .shadow(color: .gray.opacity(0.2), radius: 8)
                            }
                        }

                    TextField("닉네임을 입력해주세요.", text: $diver.nickname)
                        .font(.system(.largeTitle, design: .rounded))
                        .bold()
                        .opacity(0.7)
                        .padding(.bottom, 32)
                        .multilineTextAlignment(.center)
                        .disabled(!isEditing)

                    if isEditing {
                        HStack {
                            ForEach(Colors.allCases, id: \.self) { color in
                                Circle()
                                    .fill(color.toColor)
                                    .frame(width: 28)
                                    .shadow(
                                        color: .gray.opacity(0.2),
                                        radius: 8
                                    )
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
                                    .opacity(0.7)
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
                    .shadow(color: .gray.opacity(0.2), radius: 8)
                }
                .padding()
                .padding(.top, 80)
            }

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
                }

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.gray)
                        .padding(8)
                        .background(Circle().fill(.regularMaterial))
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

#Preview {
    DiverCardDetailView(diver: .constant(Diver.builtin))
}
