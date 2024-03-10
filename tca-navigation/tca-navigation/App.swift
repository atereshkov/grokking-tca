import SwiftUI
import ComposableArchitecture

@main
struct NavigationApp: App {

    let store = Store(initialState: ContactsReducer.State(), reducer: {
        ContactsReducer()
    })

    var body: some Scene {
        WindowGroup {
            ContactsView(store: store)
        }
    }
}
