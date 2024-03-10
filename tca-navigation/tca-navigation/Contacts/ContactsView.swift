import SwiftUI
import ComposableArchitecture

struct ContactsView: View {

    let store: StoreOf<ContactsReducer>

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.contacts) { contact in
                    Text(contact.name)
                }
            }
        }
        .navigationTitle("Contacts")
        .toolbar {
            ToolbarItem {
                Button {
                    store.send(.addButtonTapped)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    ContactsView(
        store: Store(
            initialState: ContactsReducer.State(
                contacts: [
                    Contact(id: UUID(), name: "Bob"),
                    Contact(id: UUID(), name: "Bob Jr"),
                    Contact(id: UUID(), name: "Bob Sr"),
                ]
            )
        ) {
            ContactsReducer()
        }
    )
}
