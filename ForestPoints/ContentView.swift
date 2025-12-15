
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .font(.signikaSC(size: 24))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
