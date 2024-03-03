import ComposableArchitecture
import SwiftUI

@main
struct EssentialsApp: App {
    var body: some Scene {
        WindowGroup {
            CounterView(store: Store(initialState: CounterFeature.State(), reducer: {
                CounterFeature()
                    ._printChanges()
            }))
        }
    }
}
