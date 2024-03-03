import ComposableArchitecture
import SwiftUI

@main
struct EssentialsApp: App {
    var body: some Scene {
        WindowGroup {
            CounterView(store: Store(initialState: CounterReducer.State(), reducer: {
                CounterReducer()
                    ._printChanges()
            }))
        }
    }
}
