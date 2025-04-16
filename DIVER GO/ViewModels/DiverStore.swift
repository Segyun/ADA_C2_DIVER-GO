//
//  DiverStore.swift
//  DIVER GO
//
//  Created by 정희균 on 4/15/25.
//

import Foundation

class DiverStore: ObservableObject {
    @Published var divers: [Diver] = []
    @Published var mainDiver = Diver()
    
    static var shared = DiverStore()
    
    func loadData() {
        loadDiversData()
        loadMainDiverData()
    }
    
    func saveData() {
        saveDiversData()
        saveMainDiverData()
    }
    
    private static func getDiversFileURL() throws -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("divers.data")
    }
    
    private static func getMainDiverFileURL() throws -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
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
            
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
            
            print("Data saved: \(divers.count) divers")
        } catch {
            print("Failed to save data")
        }
    }
    
    private func saveMainDiverData() {
        do {
            let fileURL = try DiverStore.getMainDiverFileURL()
            let data = try JSONEncoder().encode(mainDiver)
            
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
            
            print("Main diver saved")
        } catch {
            print("Failed to save main diver data")
        }
    }
}

