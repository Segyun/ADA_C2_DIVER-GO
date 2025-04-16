//
//  MissionListView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/16/25.
//

import SwiftUI

struct MissionListView: View {
    // ScrollViewReader에서 사용할 ID
    private let missionHeaderId = "mission"
    private let badgeHeaderId = "badge"

    var body: some View {
        ScrollViewReader { proxy in
            ZStack {
                Color.C_4
                    .ignoresSafeArea()

                ScrollView {
                    LazyVStack(
                        alignment: .leading,
                        pinnedViews: [.sectionHeaders]
                    ) {
                        Section {
                            ForEach(0..<3) { _ in
                                MissionRowView()
                            }
                        } header: {
                            MissionHeaderView()
                                .id(missionHeaderId)
                                .onTapGesture {
                                    withAnimation {
                                        proxy.scrollTo(
                                            missionHeaderId,
                                            anchor: .top
                                        )
                                    }
                                }
                        }

                        Section {
                            LazyVGrid(
                                columns: Array(
                                    repeating: GridItem(),
                                    count: 3
                                )
                            ) {
                                ForEach(0..<10, id: \.self) { _ in
                                    BadgeItemView()
                                }
                            }
                        } header: {
                            BadgeHeaderView()
                                .id(badgeHeaderId)
                                .onTapGesture {
                                    withAnimation {
                                        proxy.scrollTo(
                                            badgeHeaderId,
                                            anchor: .top
                                        )
                                    }
                                }
                        }
                    }
                    .padding()
                }
                .clipped()
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Subviews

// 미션 리스트의 미션 행을 나타내는 뷰
struct MissionRowView: View {
    var body: some View {
        VStack {
            HStack {
                Text("관심분야 Tech인 다이버 만나기")
                    .font(.headline)
                Spacer()
            }
            HStack {
                ProgressView(value: 1.0 / 3.0)
                    .progressViewStyle(.linear)
                Text("1/3")
            }
        }
        .padding(.vertical)
    }
}

// 미션 리스트의 미션 헤더를 나타내는 뷰
struct MissionHeaderView: View {
    var body: some View {
        HStack {
            Text("오늘의 미션")
                .font(.title)
                .bold()
            Spacer()
        }
        .padding(.bottom)
        .frame(maxWidth: .infinity)
        .background {
            Color.C_4
        }
    }
}

// 미션 리스트의 배지 행을 나타내는 뷰
struct BadgeItemView: View {
    var body: some View {
        VStack {
            ProfileImageView()
            Text("배지 이름")
            Text("배지 달성 조건")
                .font(.caption)
        }
        .padding()
    }
}

// 미션 리스트의 배지 헤더를 나타내는 뷰
struct BadgeHeaderView: View {
    var body: some View {
        HStack {
            Text("배지")
                .font(.title)
                .bold()
            Spacer()
        }
        .padding(.bottom)
        .frame(maxWidth: .infinity)
        .background {
            Color.C_4
        }
    }
}

#Preview {
    MissionListView()
}
