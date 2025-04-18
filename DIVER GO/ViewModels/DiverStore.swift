//
//  DiverStore.swift
//  DIVER GO
//
//  Created by 정희균 on 4/15/25.
//

import Foundation
import SwiftUI

class DiverStore: ObservableObject {
    static var shared = DiverStore()

    private init() {}

    @Published var divers: [Diver] = []
    @Published var mainDiver = Diver()
    
    @Published var selectedDiver: Diver?
    
    func getDiverColor(_ diver: Diver) -> Color {
        if diver.id == mainDiver.id {
            return .C_1
        }
        
        let dateComponents = Calendar.current
            .dateComponents([.day], from: diver.updatedAt, to: Date())
        
        if let days = dateComponents.day, days < 1 {
            return .C_2
        }
        return .C_3
    }

    func getSharedDiver(_ urlQueryItems: [URLQueryItem]) {
        var diver = Diver()

        diver.infoList.removeAll()

        for item in urlQueryItems {
            switch item.name {
            case DiverQuery.ID.rawValue:
                diver.id = UUID(uuidString: item.value!)!
            case DiverQuery.NICKNAME.rawValue:
                diver.nickname = item.value ?? ""
            case DiverQuery.EMOJI.rawValue:
                diver.emoji = item.value ?? ""
            case DiverQuery.CREATED_AT.rawValue:
                diver.createdAt = item.value?.toDate() ?? Date()
            case DiverQuery.UPDATED_AT.rawValue:
                diver.updatedAt = item.value?.toDate() ?? Date()
            default:
                diver.infoList
                    .append(
                        DiverInfo(
                            title: item.name,
                            description: item.value ?? ""
                        )
                    )
            }
        }

        guard let index = divers.firstIndex(where: { $0.id == diver.id })
        else {
            divers.append(diver)
            selectedDiver = divers.last!
            return
        }

        divers[index] = diver
        selectedDiver = divers[index]
    }
    
    func deleteDiver(_ diver: Diver?) {
        guard let diver else { return }
        
        divers.removeAll(where: { $0.id == diver.id })
    }

    func loadData() {
        loadDiversData()
        loadMainDiverData()
    }

    func saveData() {
        saveDiversData()
        saveMainDiverData()
    }

    private static func getDiversFileURL() throws -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[
            0
        ]
        .appendingPathComponent("divers.data")
    }

    private static func getMainDiverFileURL() throws -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[
            0
        ]
        .appendingPathComponent("mainDiver.data")
    }

    private func loadDiversData() {
        do {
            let fileURL = try DiverStore.getDiversFileURL()
            let data = try Data(contentsOf: fileURL)

            divers = try JSONDecoder().decode([Diver].self, from: data)

            print("Data loaded: \(divers.count) divers")
        } catch {
            print("Failed to load data")
        }
    }

    private func loadMainDiverData() {
        do {
            let fileURL = try DiverStore.getMainDiverFileURL()
            let data = try Data(contentsOf: fileURL)

            mainDiver = try JSONDecoder().decode(Diver.self, from: data)

            print("Main diver loaded")
        } catch {
            print("Failed to load main diver data")
        }
    }

    private func saveDiversData() {
        do {
            let fileURL = try DiverStore.getDiversFileURL()
            let data = try JSONEncoder().encode(divers)

            try data.write(
                to: fileURL,
                options: [.atomic, .completeFileProtection]
            )

            print("Data saved: \(divers.count) divers")
        } catch {
            print("Failed to save data")
        }
    }

    private func saveMainDiverData() {
        do {
            let fileURL = try DiverStore.getMainDiverFileURL()
            let data = try JSONEncoder().encode(mainDiver)

            try data.write(
                to: fileURL,
                options: [.atomic, .completeFileProtection]
            )

            print("Main diver saved")
        } catch {
            print("Failed to save main diver data")
        }
    }
}
