import SwiftUI
import ONXYellowstone

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                YSButton("text")
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
            .navigationTitle("Watch Tower")
        }
    }
}

#Preview {
    ContentView()
}
