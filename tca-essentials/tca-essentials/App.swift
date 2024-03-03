import ComposableArchitecture
import SwiftUI

@main
struct EssentialsApp: App {
    static let store = Store(initialState: AppReducer.State()) {
        AppReducer()
    }

    var body: some Scene {
        WindowGroup {
            AppView(store: EssentialsApp.store)
        }
    }
}
