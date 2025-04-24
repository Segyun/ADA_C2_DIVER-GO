//
//  Onboarding.swift
//  DIVER GO
//
//  Created by 정희균 on 4/24/25.
//

import AVKit
import SwiftUI

struct Onboarding: View {
    enum OnboardingPage {
        case intro
        case profile
        case outro
    }

    @Binding var onboardingState: OnboardingState
    @Binding var mainDiver: Diver

    @State private var currentPage: OnboardingPage = .intro

    var body: some View {
        ZStack {
            GradientBackgroundView(diver: mainDiver)

            Group {
                switch currentPage {
                case .intro:
                    IntroView
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .bottom),
                                removal: .move(edge: .top)
                            )
                        )
                case .profile:
                    ProfileView
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .bottom),
                                removal: .move(edge: .top)
                            )
                        )
                case .outro:
                    OutroView
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .bottom),
                                removal: .move(edge: .top)
                            )
                        )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil
                )
            }

            Button {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil
                )
                withAnimation {
                    switch currentPage {
                    case .intro:
                        currentPage = .profile
                    case .profile:
                        currentPage = .outro
                    case .outro:
                        onboardingState = .completed
                    }
                }
            } label: {
                Text("계속하기")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(mainDiver.color.toColor)
                    .glassOpacity()
                    .padding()
                    .background(
                        .regularMaterial,
                        in: RoundedRectangle(cornerRadius: 20)
                    )
            }
            .padding()
            .padding(.top, 32)
            .background {
                UnevenRoundedRectangle(
                    bottomLeadingRadius: 30,
                    bottomTrailingRadius: 30
                )
                .fill(.ultraThinMaterial)
                .mask {
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .black, location: 0.3),
                            .init(color: .black, location: 1),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .ignoresSafeArea()
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .disabled(currentPage == .profile && mainDiver.nickname.isEmpty)
        }
        .onAppear {
            if let url = Bundle.main.url(
                forResource: "Share",
                withExtension: "mov"
            ) {
                let asset = AVURLAsset(url: url)
                let item = AVPlayerItem(asset: asset)
                self.looper = AVPlayerLooper(player: player, templateItem: item)
            }
        }
    }

    private var IntroView: some View {
        VStack {
            Text("DIVER GO")
                .font(.system(.largeTitle, design: .rounded))
                .bold()

            Text("다른 다이버를 만나보세요.")
        }
        .glassOpacity()
    }

    private var ProfileView: some View {
        DiverCardDetailView(
            diver: mainDiver,
            isEditing: .constant(true),
            isEditAvailable: true,
            onboardingMode: true
        )
    }

    @State private var player = AVQueuePlayer()
    @State private var looper: AVPlayerLooper?

    private var OutroView: some View {
        VStack {
            Group {
                Text("홈화면에서 AirDrop으로 공유해보세요.")
            }
            .font(.headline)

            VStack(spacing: 10) {
                VideoPlayer(player: player)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Group {
                    Text(
                        Image(systemName: "square.and.arrow.up")
                    ) + Text(" 버튼으로도 공유할 수 있어요.")
                }
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20))
            .frame(maxWidth: 300, maxHeight: 400)
            .padding(.horizontal)
        }
        .onAppear {
            player.play()
        }
        .onDisappear {
            player.pause()
        }
    }
}

#Preview {
    @Previewable @State var onboardingState: OnboardingState = .required
    @Previewable @State var mainDiver = Diver()

    return Onboarding(onboardingState: $onboardingState, mainDiver: $mainDiver)
}
