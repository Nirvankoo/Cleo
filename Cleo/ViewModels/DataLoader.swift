import Foundation

class DataLoader {
    static func loadJSON<T: Codable>(_ filename: String, as type: T.Type) -> T {

        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: "json") else {
            fatalError("Missing file: \(filename)")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Cannot load file: \(filename)")
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("❌ Decoding error:", error)
            fatalError("Decoding error: \(filename)")
        }
    }
}
//  DataLoader.swift
//  Cleo
//
//  Created by Nina on 2026-04-26.
//

