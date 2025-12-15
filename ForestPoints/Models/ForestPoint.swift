import Foundation
import CoreLocation

struct ForestPoint: Identifiable, Codable {
    let id: UUID
    var imageData: Data?
    var type: PointType
    var name: String
    var coordinates: String
    var notes: String
    var isFavourite: Bool
    var markAsType: MarkAsType?
    var collectionId: UUID?
    var desiredDate: Date?
    
    init(
        id: UUID = UUID(),
        imageData: Data? = nil,
        type: PointType = .clearing,
        name: String = "",
        coordinates: String = "",
        notes: String = "",
        isFavourite: Bool = false,
        markAsType: MarkAsType? = nil,
        collectionId: UUID? = nil,
        desiredDate: Date? = nil
    ) {
        self.id = id
        self.imageData = imageData
        self.type = type
        self.name = name
        self.coordinates = coordinates
        self.notes = notes
        self.isFavourite = isFavourite
        self.markAsType = markAsType
        self.collectionId = collectionId
        self.desiredDate = desiredDate
    }
    
    func parseCoordinates() -> (latitude: Double, longitude: Double) {
        let parts = coordinates.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        guard parts.count == 2 else {
            return (latitude: 0.0, longitude: 0.0)
        }
        
        var latString = parts[0]
        var lonString = parts[1]
        
        latString = latString.replacingOccurrences(of: "N", with: "")
            .replacingOccurrences(of: "S", with: "-")
        lonString = lonString.replacingOccurrences(of: "E", with: "")
            .replacingOccurrences(of: "W", with: "-")
        
        guard let lat = Double(latString),
              let lon = Double(lonString) else {
            return (latitude: 0.0, longitude: 0.0)
        }
        
        return (latitude: lat, longitude: lon)
    }
}

