import SwiftUI

public struct WatchTowerView: View {
    private let watchTower: WatchTower = .shared
    public init(){
        
    }
    public var body: some View {
        Button("Upload") {
            Task {
                do {
                    try await watchTower.upload()
                } catch {
                    print("Failed to upload: \(error)")
                }
            }
        }
        List {
            ForEach(watchTower.events) { event in
                VStack(alignment: .leading) {
                    Text("Type: \(event.type)")
                    Text("Created at: \(event.timestamp)")
                    Text(event.value)
                }
            }
        }
    }
}

#Preview {
    WatchTowerView()
}
