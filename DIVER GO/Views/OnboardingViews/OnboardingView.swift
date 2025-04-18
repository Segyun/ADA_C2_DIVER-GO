//
//  OnboardingView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/14/25.
//

import MCEmojiPicker
import SwiftUI

struct OnboardingView: View {
    @Binding var onboardingState: OnboardingState
    
    private let backgroundColors: [[Color]] = [[.C_2, .C_3], [.C_3, .C_4]]
    
    @ObservedObject private var diverStore = DiverStore.shared
    @State private var currentPage = 0

    var body: some View {
        ZStack {
            BackgroundGradient

            VStack {
                Group {
                    switch currentPage {
                    case 0:
                        FirstOnboardingView
                    case 1:
                        SecondOnboardingView
                    case 2:
                        ThirdOnboardingView
                    default:
                        ProgressView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .bottom),
                        removal: .move(edge: .top)
                    )
                )

                Button {
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil
                    )
                    if currentPage == 2 {
                        withAnimation {
                            onboardingState = .disappear
                        } completion: {
                            withAnimation {
                                onboardingState = .completed
                            }
                        }
                    } else {
                        withAnimation {
                            currentPage = (currentPage + 1) % 4
                        }
                    }
                } label: {
                    Text(currentPage == 2 ? "시작하기" : "계속하기")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .padding()
                .buttonStyle(.borderedProminent)
                .disabled(diverStore.mainDiver.nickname.isEmpty)
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: Background View
    
    private var BackgroundGradient: some View {
        Group {
            switch currentPage {
            case 0, 1:
                LinearGradient(
                    colors: backgroundColors[currentPage],
                    startPoint: .top,
                    endPoint: .bottom
                )

            default:
                Color.C_4
            }
        }
        .animation(.default, value: currentPage)
        .ignoresSafeArea()
    }
    
    // MARK: First Onboarding View

    @State private var isEmojiSelecting = false

    private var FirstOnboardingView: some View {
        VStack {
            Text("DIVER GO")
                .font(.largeTitle)
                .bold()
                .padding()
            VStack {
                ZStack {
                    ProfileImageView(
                        emoji: diverStore.mainDiver.emoji,
                        strokeColor: .C_1
                    )
                    .frame(width: 150)
                    .padding(.bottom)

                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .symbolRenderingMode(.multicolor)
                        .foregroundStyle(.C_1)
                        .offset(x: 48, y: 48)
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
                    selectedEmoji: $diverStore.mainDiver.emoji
                )
                TextField("닉네임을 입력해주세요.", text: $diverStore.mainDiver.nickname)
                    .multilineTextAlignment(.center)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.C_3)
                    }
            }
            .frame(maxHeight: .infinity)
        }
        .padding()
    }

    // MARK: Second Onboarding View
    
    @State private var newInfo = DiverInfo()
    @State private var isAddingNewInfo = false

    private var SecondOnboardingView: some View {
        VStack {
            Text("반가워요, \(diverStore.mainDiver.nickname)!")
                .font(.largeTitle)
                .bold()
                .padding()
            VStack {
                List {
                    Section(
                        header: Text(
                            "\(diverStore.mainDiver.nickname)에 대해 알려주세요."
                        )
                    ) {
                        ForEach($diverStore.mainDiver.infoList) { info in
                            DiverInfoRowEditView(diverInfo: info)
                                .deleteDisabled(
                                    info.isRequired.wrappedValue
                                )
                        }
                        .onDelete { indexSet in
                            diverStore.mainDiver.infoList
                                .remove(atOffsets: indexSet)
                        }
                    }
                    .listRowBackground(Color.C_3)

                    Section(header: Text("추가하고 싶은 정보가 있나요?")) {
                        Button {
                            isAddingNewInfo.toggle()
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
            }
            .frame(maxHeight: .infinity)
        }
        .alert(
            "새로운 정보를 추가하시겠습니까?",
            isPresented: $isAddingNewInfo
        ) {
            TextField("제목", text: $newInfo.title)
            Button("취소", role: .cancel) {
                isAddingNewInfo = false
            }
            Button("추가하기") {
                withAnimation {
                    diverStore.mainDiver.infoList.append(newInfo)
                }
                newInfo = DiverInfo()
            }
            .disabled(newInfo.title.isEmpty)
        }
    }
    
    // MARK: Third Onboarding View

    private var ThirdOnboardingView: some View {
        VStack {
            Text("자신의 다이버 프로필에서 ")
                + Text(
                    Image(systemName: "square.and.arrow.up")
                ) + Text("를 눌러\n다른 다이버와 공유해보세요.")
        }
        .font(.headline)
    }
}

#Preview {
    @Previewable @State var onboardingState: OnboardingState = .required

    return OnboardingView(onboardingState: $onboardingState)
}
