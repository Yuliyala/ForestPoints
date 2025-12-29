import Foundation
import SwiftUI

enum PointType: String, Codable, CaseIterable {
    case restArea
    case clearing
    case spring
    case mushroomSpot
    
    var title: String {
        switch self {
        case .restArea:
            "Rest Area"
        case .clearing:
            "Clearing"
        case .spring:
            "Spring"
        case .mushroomSpot:
            "Mushroom Spot"
        }
    }
    
    var image: ImageResource {
        switch self {
        case .restArea:
            .restIcon
        case .clearing:
            .clearing
        case .spring:
            .spring
        case .mushroomSpot:
            .mushroom
        }
    }
}

