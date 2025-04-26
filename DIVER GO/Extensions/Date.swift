//
//  Date.swift
//  DIVER GO
//
//  Created by 정희균 on 4/18/25.
//

import Foundation

extension Date {
    /// 날짜를 문자열로 변환합니다.
    /// - Returns: 날짜 문자열
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        return dateFormatter.string(from: self)
    }
    
    /// 현재 날짜와 비교하여 지난 날을 반환합니다.
    /// - Returns: 지난 날
    func lastDays() -> Int {
        let dateComponents = Calendar.current.dateComponents([.day], from: self, to: Date())
        return dateComponents.day ?? 0
    }
}
