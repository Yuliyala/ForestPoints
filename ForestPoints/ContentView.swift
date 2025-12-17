
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .font(.signikaBold(size: 24))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
