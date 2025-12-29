import Foundation

class VisitService {
    static let shared = VisitService()
    
    private let userDefaults = UserDefaults.standard
    private let visitsKey = "visits_key"
    
    private init() {}
    
    func save(_ visit: Visit) {
        var visits = getAll()
        
        if let index = visits.firstIndex(where: { $0.id == visit.id }) {
            visits[index] = visit
        } else {
            visits.append(visit)
        }
        
        saveVisits(visits)
    }
    
    func getAll() -> [Visit] {
        guard let data = userDefaults.data(forKey: visitsKey) else {
            return []
        }
        
        do {
            let visits = try JSONDecoder().decode([Visit].self, from: data)
            return visits
        } catch {
            return []
        }
    }
    
    func getByPointId(_ pointId: UUID) -> [Visit] {
        return getAll().filter { $0.pointId == pointId }
    }
    
    func delete(id: UUID) {
        var visits = getAll()
        visits.removeAll(where: { $0.id == id })
        saveVisits(visits)
    }
    
    func deleteAll() {
        userDefaults.removeObject(forKey: visitsKey)
    }
    
    private func saveVisits(_ visits: [Visit]) {
        do {
            let data = try JSONEncoder().encode(visits)
            userDefaults.set(data, forKey: visitsKey)
        } catch {
            return
        }
    }
}

