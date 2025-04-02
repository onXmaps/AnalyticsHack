import SwiftUI
import ONXYellowstone
import ONXWatchTower

struct ContentView: View {
    private let apiClient = SwapiClient()
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Yellowstone Components")) {
                    YSButton("Button", action: { print("I did something") })
                        .primary()
                    YSButton("Slow button", action: { try await Task.sleep(for: .seconds(3))})
                        .primary()
                    YSChip(
                        viewModel: YSSelectionChipViewModel(
                            name: YSText("Chip 1")
                        )
                    )
                }
                Section(header: Text("Network Request")) {
                    YSButton("Query Star Wars API") {
                        let _ = try await apiClient.getPeople(1)
                    }
                }
                Section(header: Text("Watch Tower")) {
                    NavigationLink(destination: WatchTowerView()) {
                        YSButton("View WatchTower Events")
                    }
                }
            }
            .padding()
            .navigationTitle("Watch Tower")
        }
    }
}

#Preview {
    ContentView()
}
