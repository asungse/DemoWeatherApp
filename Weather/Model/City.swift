//
//  City.swift
//  Weather
//
//  Created by Alvin on 10/10/2021.
//

import UIKit
import ObjectBox

final class City: Entity, Codable, Hashable {
    var entityId: Id = 0
    var id = 0
    // objectbox: index
    var name = ""
    var inSearchHistory = false
    var lastSearchTime = Date(timeIntervalSince1970: 0)
    
    static let shared = City()
    
    // objectbox: transient
    private var store: ObjectBox.Store?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    required init() {}
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    init(id: Int, name: String, inSearchHistory: Bool, lastSearchTime: Date) {
        self.id = id
        self.name = name
        self.inSearchHistory = inSearchHistory
        self.lastSearchTime = lastSearchTime
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(inSearchHistory)
        hasher.combine(lastSearchTime)
    }
    
    static func ==(lhs: City, rhs: City) -> Bool {
        return lhs.entityId == rhs.entityId &&
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.inSearchHistory == rhs.inSearchHistory &&
        lhs.lastSearchTime == rhs.lastSearchTime
    }
    
    // MARK: - Create city entities for preloaded list
    
    func createObjectBoxStoreIfNotExist() {
        let databaseName = "weather"
        do {
            var directory = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(Bundle.main.bundleIdentifier!)
            directory.appendPathComponent(databaseName)
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            store = try Store(directoryPath: directory.path)
        }
        catch let error {
            print(error)
        }
    }
    
    func saveCitiesIntoDBIfNotExist() {
        guard let store = store else { return }
        let box = store.box(for: City.self)
        guard let isEmpty = try? box.isEmpty() else { return }
        guard isEmpty else { return }
        DispatchQueue.main.async {
            if let asset = NSDataAsset(name: "city.list") {
                do {
                    let cities = try JSONDecoder().decode([City].self, from: asset.data)
                    self.putToBox(cities: cities)
                }
                catch let error {
                    print(error)
                }
            }
        }
    }
    
    // MARK: - Create city entites
    
    func putToBox(city: City) {
        guard let store = store else { return }
        let box = store.box(for: City.self)
        let _ = try? box.put(city)
    }
    
    func putToBox(cities: [City]) {
        guard let store = store else { return }
        let box = store.box(for: City.self)
        let _ = try? box.put(cities)
    }
    
    // MARK: - Update city entites
    
    func updateBox(city: City, inSearchHistory: Bool) {
        city.inSearchHistory = inSearchHistory
        city.lastSearchTime = inSearchHistory ? Date.now : Date.init(timeIntervalSince1970: 0)
        putToBox(city: city)
    }
    
    func updateBox(cities: [City], inSearchHistory: Bool) {
        for city in cities {
            city.inSearchHistory = inSearchHistory
            city.lastSearchTime = inSearchHistory ? Date.now : Date.init(timeIntervalSince1970: 0)
        }
        putToBox(cities: cities)
    }
    
    // MARK: - Read city entites
    
    func getFromBox(cityNameWithPrefix prefix: String, inSearchHistoryOnly: Bool) -> [City]? {
        guard let store = store else { return nil }
        let box = store.box(for: City.self)
        let query: Query<City>? = try? box.query {
            if inSearchHistoryOnly {
                return City.name.hasPrefix(prefix, caseSensitive: false) && City.inSearchHistory.isEqual(to: true)
            }
            else {
                return City.name.hasPrefix(prefix, caseSensitive: false)
            }
        }.ordered(by: City.lastSearchTime, flags: .descending)
            .build()
        return try? query?.find()
    }
    
    func getFromBox(cityName: String) -> [City]? {
        guard let store = store else { return nil }
        let box = store.box(for: City.self)
        let query = try? box.query {
            City.name.isEqual(to: cityName, caseSensitive: false)
        }.build()
        return try? query?.find()
    }
    
    func getLastSearchedCityFromBox() -> City? {
        guard let store = store else { return nil }
        let box = store.box(for: City.self)
        let query = try? box.query {
            City.inSearchHistory.isEqual(to: true)
        }.ordered(by: City.lastSearchTime, flags: .descending)
            .build()
        return try? query?.find().first
    }
    
    func getAllCitiesInSearchHistory() -> [City]? {
        guard let store = store else { return nil }
        let box = store.box(for: City.self)
        let query = try? box.query {
            City.inSearchHistory.isEqual(to: true)
        }.ordered(by: City.lastSearchTime, flags: .descending)
            .build()
        return try? query?.find()
    }
    
    func getAllCitiesFromBox() -> [City]? {
        guard let store = store else { return nil }
        let box = store.box(for: City.self)
        return try? box.all()
    }
}
