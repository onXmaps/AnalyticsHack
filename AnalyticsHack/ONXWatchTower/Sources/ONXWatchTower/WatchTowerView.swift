import SwiftUI

public struct WatchTowerView: View {
    private let watchTower: WatchTower = .shared
    public init(){
        
    }
    public var body: some View {
        Button("Upload Events") {
            print("uploaded")
            watchTower.reset()
        }
        List {
            ForEach(watchTower.events) { event in
                VStack(alignment: .leading) {
                    Text("Type: \(event.type)")
                    Text(event.value)
                }
            }
        }
    }
}

#Preview {
    WatchTowerView()
}
