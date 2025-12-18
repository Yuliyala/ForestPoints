import Foundation
import SwiftUI

enum MoodType: String, Codable, CaseIterable, Equatable {
    case relaxed
    case curious
    case spring
    
    var title: String {
        switch self {
        case .relaxed:
            "Relaxed"
        case .curious:
            "Curious"
        case .spring:
            "Spring"
        }
    }
    
    var image: ImageResource {
        switch self {
        case .relaxed:
            .relaxedIcon
        case .curious:
            .curiousIcon
        case .spring:
            .springIcon
        }
    }
}

