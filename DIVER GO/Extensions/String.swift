//
//  String.swift
//  DIVER GO
//
//  Created by 정희균 on 4/18/25.
//

import Foundation

extension String {
    /// 문자열을 Date로 변환합니다.
    /// - Returns: 변환된 Date 객체
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        return dateFormatter.date(from: self)
    }
}
