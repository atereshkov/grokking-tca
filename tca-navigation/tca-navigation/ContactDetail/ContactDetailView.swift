import SwiftUI
import ComposableArchitecture

struct ContactDetailView: View {

    @Bindable var store: StoreOf<ContactDetailReducer>

    var body: some View {
        Form {
            Button("Delete") {
                store.send(.deleteButtonTapped)
            }
        }
        .navigationBarTitle(Text(store.contact.name))
        .alert($store.scope(state: \.alert, action: \.alert))
    }

}

#Preview {
    NavigationStack {
        ContactDetailView(store: Store(initialState: ContactDetailReducer.State(contact: Contact(id: UUID(), name: "Blob"))) {
            ContactDetailReducer()
        })
    }
}
