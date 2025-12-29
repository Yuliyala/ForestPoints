import SwiftUI

struct MainView: View {
    @State var tab: Tabs = .map
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    switch tab {
                    case .map:
                        MapView()
                    case .collections:
                        CollectionsView()
                    case .visitHistory:
                        VisitHistoryView()
                    case .favorites:
                        PlansAndFavoritesView()
                    case .settings:
                        SettingsView()
                    }
                    
                    Spacer()
                    CustomTabView(currentTab: $tab)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                }
                .bgSetup()
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

