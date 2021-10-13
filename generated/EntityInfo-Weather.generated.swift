// Generated using the ObjectBox Swift Generator — https://objectbox.io
// DO NOT EDIT

// swiftlint:disable all
import ObjectBox
import Foundation

// MARK: - Entity metadata


extension City: ObjectBox.__EntityRelatable {
    internal typealias EntityType = City

    internal var _id: EntityId<City> {
        return EntityId<City>(self.entityId.value)
    }
}

extension City: ObjectBox.EntityInspectable {
    internal typealias EntityBindingType = CityBinding

    /// Generated metadata used by ObjectBox to persist the entity.
    internal static var entityInfo = ObjectBox.EntityInfo(name: "City", id: 1)

    internal static var entityBinding = EntityBindingType()

    fileprivate static func buildEntity(modelBuilder: ObjectBox.ModelBuilder) throws {
        let entityBuilder = try modelBuilder.entityBuilder(for: City.self, id: 1, uid: 2348210873696258048)
        try entityBuilder.addProperty(name: "entityId", type: Id.entityPropertyType, flags: [.id], id: 6, uid: 4314517729417287424)
        try entityBuilder.addProperty(name: "id", type: Int.entityPropertyType, id: 8, uid: 1561043122139846400)
        try entityBuilder.addProperty(name: "name", type: String.entityPropertyType, flags: [.indexHash, .indexed], id: 3, uid: 3002826613315017984, indexId: 1, indexUid: 7950533727145164544)
        try entityBuilder.addProperty(name: "inSearchHistory", type: Bool.entityPropertyType, id: 4, uid: 7377022410831183360)
        try entityBuilder.addProperty(name: "lastSearchTime", type: Date.entityPropertyType, id: 5, uid: 3813529104608206848)

        try entityBuilder.lastProperty(id: 10, uid: 1951387303465048576)
    }
}

extension City {
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { City.entityId == myId }
    internal static var entityId: Property<City, Id, Id> { return Property<City, Id, Id>(propertyId: 6, isPrimaryKey: true) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { City.id > 1234 }
    internal static var id: Property<City, Int, Void> { return Property<City, Int, Void>(propertyId: 8, isPrimaryKey: false) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { City.name.startsWith("X") }
    internal static var name: Property<City, String, Void> { return Property<City, String, Void>(propertyId: 3, isPrimaryKey: false) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { City.inSearchHistory == true }
    internal static var inSearchHistory: Property<City, Bool, Void> { return Property<City, Bool, Void>(propertyId: 4, isPrimaryKey: false) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { City.lastSearchTime > 1234 }
    internal static var lastSearchTime: Property<City, Date, Void> { return Property<City, Date, Void>(propertyId: 5, isPrimaryKey: false) }

    fileprivate func __setId(identifier: ObjectBox.Id) {
        self.entityId = Id(identifier)
    }
}

extension ObjectBox.Property where E == City {
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .entityId == myId }

    internal static var entityId: Property<City, Id, Id> { return Property<City, Id, Id>(propertyId: 6, isPrimaryKey: true) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .id > 1234 }

    internal static var id: Property<City, Int, Void> { return Property<City, Int, Void>(propertyId: 8, isPrimaryKey: false) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .name.startsWith("X") }

    internal static var name: Property<City, String, Void> { return Property<City, String, Void>(propertyId: 3, isPrimaryKey: false) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .inSearchHistory == true }

    internal static var inSearchHistory: Property<City, Bool, Void> { return Property<City, Bool, Void>(propertyId: 4, isPrimaryKey: false) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .lastSearchTime > 1234 }

    internal static var lastSearchTime: Property<City, Date, Void> { return Property<City, Date, Void>(propertyId: 5, isPrimaryKey: false) }

}


/// Generated service type to handle persisting and reading entity data. Exposed through `City.EntityBindingType`.
internal class CityBinding: ObjectBox.EntityBinding {
    internal typealias EntityType = City
    internal typealias IdType = Id

    internal required init() {}

    internal func generatorBindingVersion() -> Int { 1 }

    internal func setEntityIdUnlessStruct(of entity: EntityType, to entityId: ObjectBox.Id) {
        entity.__setId(identifier: entityId)
    }

    internal func entityId(of entity: EntityType) -> ObjectBox.Id {
        return entity.entityId.value
    }

    internal func collect(fromEntity entity: EntityType, id: ObjectBox.Id,
                                  propertyCollector: ObjectBox.FlatBufferBuilder, store: ObjectBox.Store) throws {
        let propertyOffset_name = propertyCollector.prepare(string: entity.name)

        propertyCollector.collect(id, at: 2 + 2 * 6)
        propertyCollector.collect(entity.id, at: 2 + 2 * 8)
        propertyCollector.collect(entity.inSearchHistory, at: 2 + 2 * 4)
        propertyCollector.collect(entity.lastSearchTime, at: 2 + 2 * 5)
        propertyCollector.collect(dataOffset: propertyOffset_name, at: 2 + 2 * 3)
    }

    internal func createEntity(entityReader: ObjectBox.FlatBufferReader, store: ObjectBox.Store) -> EntityType {
        let entity = City()

        entity.entityId = entityReader.read(at: 2 + 2 * 6)
        entity.id = entityReader.read(at: 2 + 2 * 8)
        entity.name = entityReader.read(at: 2 + 2 * 3)
        entity.inSearchHistory = entityReader.read(at: 2 + 2 * 4)
        entity.lastSearchTime = entityReader.read(at: 2 + 2 * 5)

        return entity
    }
}


/// Helper function that allows calling Enum(rawValue: value) with a nil value, which will return nil.
fileprivate func optConstruct<T: RawRepresentable>(_ type: T.Type, rawValue: T.RawValue?) -> T? {
    guard let rawValue = rawValue else { return nil }
    return T(rawValue: rawValue)
}

// MARK: - Store setup

fileprivate func cModel() throws -> OpaquePointer {
    let modelBuilder = try ObjectBox.ModelBuilder()
    try City.buildEntity(modelBuilder: modelBuilder)
    modelBuilder.lastEntity(id: 1, uid: 2348210873696258048)
    modelBuilder.lastIndex(id: 1, uid: 7950533727145164544)
    return modelBuilder.finish()
}

extension ObjectBox.Store {
    /// A store with a fully configured model. Created by the code generator with your model's metadata in place.
    ///
    /// - Parameters:
    ///   - directoryPath: The directory path in which ObjectBox places its database files for this store.
    ///   - maxDbSizeInKByte: Limit of on-disk space for the database files. Default is `1024 * 1024` (1 GiB).
    ///   - fileMode: UNIX-style bit mask used for the database files; default is `0o644`.
    ///     Note: directories become searchable if the "read" or "write" permission is set (e.g. 0640 becomes 0750).
    ///   - maxReaders: The maximum number of readers.
    ///     "Readers" are a finite resource for which we need to define a maximum number upfront.
    ///     The default value is enough for most apps and usually you can ignore it completely.
    ///     However, if you get the maxReadersExceeded error, you should verify your
    ///     threading. For each thread, ObjectBox uses multiple readers. Their number (per thread) depends
    ///     on number of types, relations, and usage patterns. Thus, if you are working with many threads
    ///     (e.g. in a server-like scenario), it can make sense to increase the maximum number of readers.
    ///     Note: The internal default is currently around 120.
    ///           So when hitting this limit, try values around 200-500.
    /// - important: This initializer is created by the code generator. If you only see the internal `init(model:...)`
    ///              initializer, trigger code generation by building your project.
    internal convenience init(directoryPath: String, maxDbSizeInKByte: UInt64 = 1024 * 1024,
                            fileMode: UInt32 = 0o644, maxReaders: UInt32 = 0, readOnly: Bool = false) throws {
        try self.init(
            model: try cModel(),
            directory: directoryPath,
            maxDbSizeInKByte: maxDbSizeInKByte,
            fileMode: fileMode,
            maxReaders: maxReaders,
            readOnly: readOnly)
    }
}

// swiftlint:enable all
