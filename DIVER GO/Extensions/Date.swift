//
//  Date.swift
//  DIVER GO
//
//  Created by 정희균 on 4/18/25.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        return dateFormatter.string(from: self)
    }
    
    func lastDays() -> Int {
        let dateComponents = Calendar.current.dateComponents([.day], from: self, to: Date())
        return dateComponents.day ?? 0
    }
}
