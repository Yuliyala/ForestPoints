import Foundation

enum MarkAsType: String, Codable {
    case wantToComeBack
    case placesForAutumn
    case placesForSunrise
    
    var title: String {
        switch self {
        case .wantToComeBack:
            "WANT TO COME BACK"
        case .placesForAutumn:
            "PLACES FOR AUTUMN"
        case .placesForSunrise:
            "PLACES FOR SUNRISE"
        }
    }
}

