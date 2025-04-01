import SwiftUI

public struct WatchTowerView: View {
    private let events: [Event]

    public init(events: [Event]) {
        self.events = events
    }

    public var body: some View {
        List {
            ForEach(events) { event in
                VStack(alignment: .leading) {
                    Text("Type: \(event.type)")
                    Text(event.value)
                }
            }
        }
    }
}

#Preview {
    WatchTowerView(events: [
        Event(id: UUID(), type: "general", value: "First Log"),
        Event(id: UUID(), type: "general", value: "Second Log"),
    ])
}
