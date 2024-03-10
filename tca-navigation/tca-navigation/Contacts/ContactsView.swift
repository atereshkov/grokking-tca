import SwiftUI
import ComposableArchitecture

struct ContactsView: View {

    @Bindable var store: StoreOf<ContactsReducer>

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.contacts) { contact in
                    HStack {
                        Text(contact.name)
                        Spacer()
                        Button {
                            store.send(.deleteButtonTapped(contact: contact))
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
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
        .sheet(item: $store.scope(state: \.addContact, action: \.addContact)) { addContactStore in
            NavigationStack {
                AddContactView(store: addContactStore)
            }
        }
        .alert($store.scope(state: \.alert, action: \.alert))
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
