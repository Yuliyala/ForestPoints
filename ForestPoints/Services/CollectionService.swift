import Foundation

class CollectionService {
    static let shared = CollectionService()
    
    private let userDefaults = UserDefaults.standard
    private let collectionsKey = "collections_key"
    
    private init() {
        initializeDefaultCollections()
    }
    
    func initializeDefaultCollections() {
        if getAll().isEmpty {
            let defaultCollections = DefaultCollection.allCases.map { $0.toCollection() }
            saveCollections(defaultCollections)
        }
    }
    
    func save(_ collection: Collection) {
        var collections = getAll()
        
        if let index = collections.firstIndex(where: { $0.id == collection.id }) {
            collections[index] = collection
        } else {
            collections.append(collection)
        }
        
        saveCollections(collections)
    }
    
    func getAll() -> [Collection] {
        guard let data = userDefaults.data(forKey: collectionsKey) else {
            return []
        }
        
        do {
            let collections = try JSONDecoder().decode([Collection].self, from: data)
            return collections
        } catch {
            return []
        }
    }
    
    func update(_ collection: Collection) {
        save(collection)
    }
    
    func delete(id: UUID) {
        var collections = getAll()
        collections.removeAll(where: { $0.id == id })
        saveCollections(collections)
    }
    
    func delete(_ collection: Collection) {
        delete(id: collection.id)
    }
    
    private func saveCollections(_ collections: [Collection]) {
        do {
            let data = try JSONEncoder().encode(collections)
            userDefaults.set(data, forKey: collectionsKey)
        } catch {
            return
        }
    }
}

