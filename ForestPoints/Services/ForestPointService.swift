import Foundation

class ForestPointService {
    static let shared = ForestPointService()
    
    private let userDefaults = UserDefaults.standard
    private let pointsKey = "forest_points_key"
    
    private init() {}
    
    func save(_ point: ForestPoint) {
        var points = getAll()
        
        if let index = points.firstIndex(where: { $0.id == point.id }) {
            points[index] = point
        } else {
            points.append(point)
        }
        
        savePoints(points)
    }
    
    func getAll() -> [ForestPoint] {
        guard let data = userDefaults.data(forKey: pointsKey) else {
            return []
        }
        
        do {
            let points = try JSONDecoder().decode([ForestPoint].self, from: data)
            return points
        } catch {
            return []
        }
    }
    
    func delete(id: UUID) {
        var points = getAll()
        points.removeAll(where: { $0.id == id })
        savePoints(points)
    }
    
    func deleteAll() {
        userDefaults.removeObject(forKey: pointsKey)
    }
    
    private func savePoints(_ points: [ForestPoint]) {
        do {
            let data = try JSONEncoder().encode(points)
            userDefaults.set(data, forKey: pointsKey)
        } catch {
            return
        }
    }
}

