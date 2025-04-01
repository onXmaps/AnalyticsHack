import SwiftUI
import ONXYellowstone
import ONXWatchTower

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Yellowstone Components")) {
                    YSButton("Button")
                        .primary()
                    YSChip(
                        viewModel: YSSelectionChipViewModel(
                            name: YSText("Chip 1")
                        )
                    )
                }
                NavigationLink(destination: WatchTowerView()) {
                    YSButton("View WatchTower Events")
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
