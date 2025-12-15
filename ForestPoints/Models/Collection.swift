import Foundation

struct Collection: Identifiable, Codable {
    let id: UUID
    var imageData: Data?
    var title: String
    
    init(id: UUID = UUID(), imageData: Data? = nil, title: String) {
        self.id = id
        self.imageData = imageData
        self.title = title
    }
}

enum DefaultCollection: String, CaseIterable {
    case views
    case observations
    case pleasantPlaces
    case landmarks
    case usefulPoints
    
    var title: String {
        switch self {
        case .views:
            "Views"
        case .observations:
            "Observations"
        case .pleasantPlaces:
            "Pleasant Places"
        case .landmarks:
            "Landmarks"
        case .usefulPoints:
            "Useful Points"
        }
    }
    
    func toCollection() -> Collection {
        Collection(title: title)
    }
}

