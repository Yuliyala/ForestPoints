import SwiftUI

enum Tabs: CaseIterable {
    case map
    case collections
    case visitHistory
    case favorites
    case settings
    
    var image: ImageResource {
        switch self {
        case .map:
            .tab1
        case .collections:
            .tab2
        case .visitHistory:
            .tab3
        case .favorites:
            .tab4
        case .settings:
            .tab5
        }
    }
    
    var imageOn: ImageResource {
        switch self {
        case .map:
            .tab1On
        case .collections:
            .tab2On
        case .visitHistory:
            .tab3On
        case .favorites:
            .tab4On
        case .settings:
            .tab5On
        }
    }
}


