import Foundation
import SwiftUI

enum MarkAsType: String, Codable {
    case wantToComeBack
    case placesForAutumn
    case placesForSunrise
    
    var title: String {
        switch self {
        case .wantToComeBack:
            "Want to come back"
        case .placesForAutumn:
            "Places for autumn"
        case .placesForSunrise:
            "Places for sunrise"
        }
    }
    
    var image: ImageResource {
        switch self {
        case .wantToComeBack:
            .comeBack
        case .placesForAutumn:
            .autumn
        case .placesForSunrise:
            .sunrise
        }
    }
}

