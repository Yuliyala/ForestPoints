import Foundation

enum MoodType: String, Codable, CaseIterable {
    case relaxed
    case curious
    
    var title: String {
        switch self {
        case .relaxed:
            "RELAXED"
        case .curious:
            "CURIOUS"
        }
    }
}

