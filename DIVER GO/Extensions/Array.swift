//
//  Array.swift
//  DIVER GO
//
//  Created by 정희균 on 4/26/25.
//

import Foundation

extension Array {
    /// 날짜를 기준으로 랜덤한 요소를 반환합니다.
    /// - Parameter date: 날짜
    /// - Returns: 랜덤한 요소
    func stableRandom(using date: Date = Date()) -> Element? {
        guard !isEmpty else { return nil }
        let day = Calendar.current.component(.day, from: date)
        let index = day % count
        return self[index]
    }
}
