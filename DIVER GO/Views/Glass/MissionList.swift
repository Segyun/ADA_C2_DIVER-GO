//
//  MissionList.swift
//  DIVER GO
//
//  Created by 정희균 on 4/24/25.
//

import MulticolorGradient
import SwiftUI

struct MissionList: View {
    var namespace: Namespace.ID
    let mainDiver: Diver
    let divers: [Diver]

    @AppStorage("lastMissionDate") private var lastMissionDate: Date?
    @AppStorage("lastMissionDiverID") private var lastMissionDiverID: String?
    
    @State private var selectedBadge: Badge?

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

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        MissionCardView(
                            divers: divers,
                            mission: .builtin,
                            tintColor: mainDiver.color.toColor
                        )
                        if let mbtiMission = Mission.mbtiMission
                            .stableRandom()
                        {
                            MissionCardView(
                                divers: divers,
                                mission: mbtiMission,
                                tintColor: mainDiver.color.toColor
                            )
                        }
                        if let randomDiver = divers.first(
                            where: {
                                $0.id.uuidString == lastMissionDiverID
                            })
                        {
                            MissionCardView(
                                divers: divers,
                                mission: .diverMission(randomDiver),
                                tintColor: mainDiver.color.toColor
                            )
                        }

                        Text("Badges")
                            .font(.system(.title, design: .rounded))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .glassOpacity()
                            .padding(.top, 32)
                            .padding(.bottom, 8)

                        LazyVGrid(
                            columns: Array(repeating: GridItem(), count: 3)
                        ) {
                            ForEach(Badge.badges) { badge in
                                BadgeCardView(badge: badge)
                                    .matchedTransitionSource(id: badge.id, in: namespace)
                                    .onTapGesture {
                                        selectedBadge = badge
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
                .scrollIndicators(.hidden)
            }

            Text("MISSIONS")
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
        }
        .navigationDestination(item: $selectedBadge) { badge in
            BadgeCardDetailView(
                namespace: namespace,
                badge: badge,
                divers: divers
            )
            .toolbarVisibility(.hidden)
            .navigationTransition(.zoom(sourceID: badge.id, in: namespace))
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace

    return NavigationStack {
        MissionList(
            namespace: namespace,
            mainDiver: .builtin,
            divers: Diver.builtins + Diver.builtins + Diver.builtins
        )
    }
}

struct MissionCardView: View {
    let divers: [Diver]
    let mission: Mission
    let tintColor: Color

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(mission.description)
                    .font(.headline)
                Spacer()
                Text("\(mission.getMissionCount(divers))/\(mission.count)")
                    .font(.subheadline)
            }
            .glassOpacity()
            .padding(.bottom)

            ProgressView(
                value: Double(mission.getMissionCount(divers))
                    / Double(
                        mission
                            .count
                    )
            )
            .tint(tintColor)
            .glassOpacity()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            Rectangle()
                .fill(.thinMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct BadgeCardView: View {
    let badge: Badge

    var body: some View {
        VStack {
            ZStack {
                Image(.badge)
                    .resizable()
                    .interpolation(.high)
                    .scaledToFit()
                    .grayscale(1)
                    .colorMultiply(badge.tintColor)
                    .padding(.bottom)
                
                if badge.category == .mbti,
                    let mbti = badge.infoDescription
                {
                    Text(mbti)
                        .font(.system(size: 20, design: .rounded))
                        .bold()
                        .foregroundStyle(badge.tintColor)
                        .opacity(0.5)
                        .offset(y: 12)
                }
            }
            .brightness(0.15)

            VStack(alignment: .center) {
                Text(badge.title)
                    .font(.system(.headline, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text(badge.description)
                    .font(.system(.caption, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
        }
        .glassOpacity()
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            VStack(spacing: 0) {
                Circle()
                    .fill(badge.tintColor)
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
        .clipShape(RoundedRectangle(cornerRadius: 20))

    }
}
struct BadgeCardDetailView: View {
    let namespace: Namespace.ID
    let badge: Badge
    let divers: [Diver]

    @Environment(\.dismiss) private var dismiss
    @State private var angle: Double = 270

    var body: some View {
        ZStack {
            Group {
                MulticolorGradient {
                    ColorStop(position: .top, color: .clear)
                    ColorStop(position: .center, color: badge.tintColor)
                    ColorStop(position: .bottom, color: .clear)
                }
                
                Rectangle()
                    .fill(.regularMaterial)
            }
            .ignoresSafeArea()
            
            VStack {
                ZStack {
                    Image(.badge)
                        .resizable()
                        .interpolation(.high)
                        .scaledToFit()
                        .grayscale(1)
                        .colorMultiply(badge.tintColor)
                        .brightness(0.15)
                    if badge.category == .mbti {
                        Text(badge.infoDescription ?? "")
                            .font(.system(size: 64, design: .rounded))
                            .bold()
                            .foregroundStyle(badge.tintColor)
                            .opacity(0.7)
                            .offset(y: 48)
                    }
                }
                .frame(width: 250)
                .rotation3DEffect(
                    .degrees(angle),
                    axis: (x: 0, y: 1, z: 0)
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            angle = Double(value.translation.width)
                        }
                        .onEnded { _ in
                            withAnimation {
                                angle = 0
                            }
                        }
                )
                .padding()
                .matchedGeometryEffect(id: badge.id, in: namespace)
                Text(badge.title)
                    .font(.headline)
                Text(badge.description)
                    .font(.footnote)
                    .padding(.bottom)
                Text(
                    "지금까지 \(badge.getBadgeCount(divers))명 만났습니다."
                )
                .font(.caption)
            }
            .glassOpacity()
            
            HStack {
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
        .onAppear {
            withAnimation(.linear(duration: 0.5)) {
                angle = 0
            }
        }
    }
}
