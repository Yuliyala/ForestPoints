import Foundation

enum PointType: String, Codable, CaseIterable {
    case clearing
    case spring
    case restArea
    case mushroomSpot
    case oldPine
    
    var title: String {
        switch self {
        case .clearing:
            "CLEARING"
        case .spring:
            "SPRING"
        case .restArea:
            "REST AREA"
        case .mushroomSpot:
            "MUSHROOM SPOT"
        case .oldPine:
            "OLD PINE"
        }
    }
}

