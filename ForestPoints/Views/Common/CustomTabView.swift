import SwiftUI

struct CustomTabView: View {
    @Binding var currentTab: Tabs
    
    var body: some View {
        HStack {
            ForEach(Tabs.allCases, id: \.self) { tab in
                Image(currentTab == tab ? tab.imageOn : tab.image)
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        currentTab = tab
                    }
            }
        }
    }
}

