//
//  Onboarding.swift
//  DIVER GO
//
//  Created by 정희균 on 4/24/25.
//

import AVKit
import SwiftUI

struct OnboardingView: View {
    @Binding var onboardingState: OnboardingState
    @Binding var mainDiver: Diver

    @State private var currentPage: OnboardingPage = .intro
    
    // 온보딩 페이지
    private enum OnboardingPage {
        case intro
        case profile
        case outro
    }

    var body: some View {
        ZStack {
            // 배경화면
            GradientBackground(color: mainDiver.color.toColor)

            // 온보딩 페이지 뷰
            Group {
                switch currentPage {
                case .intro:
                    IntroView
                case .profile:
                    ProfileView
                case .outro:
                    OutroView
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .transition(
                .asymmetric(
                    insertion: .move(edge: .bottom),
                    removal: .move(edge: .top)
                )
            )
            .onTapGesture {
                dismissKeyboard()
            }

            // 다음 버튼
            Button("계속하기") {
                dismissKeyboard()
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
            }
            .buttonStyle(PrimaryButtonStyle(color: mainDiver.color.toColor))
            .padding()
            .disabled(currentPage == .profile && mainDiver.nickname.isEmpty)
            .padding(.top, 32)
            .background {
                FadingBackground()
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(.keyboard)
        }
        .onAppear {
            loadVideo()
        }
    }

    // MARK: - Onboarding Pages

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

    // MARK: - Helper Methods

    /// 비디오를 불러옵니다.
    private func loadVideo() {
        if let url = Bundle.main.url(
            forResource: "Share",
            withExtension: "mov"
        ) {
            let asset = AVURLAsset(url: url)
            let item = AVPlayerItem(asset: asset)

            looper = AVPlayerLooper(player: player, templateItem: item)
        }
    }

    /// 키보드를 숨깁니다.
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

#Preview {
    @Previewable @State var onboardingState: OnboardingState = .required
    @Previewable @State var mainDiver = Diver()

    return OnboardingView(onboardingState: $onboardingState, mainDiver: $mainDiver)
}
