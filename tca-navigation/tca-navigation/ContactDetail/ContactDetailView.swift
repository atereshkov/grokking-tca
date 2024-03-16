import SwiftUI
import ComposableArchitecture

struct ContactDetailView: View {

    let store: StoreOf<ContactDetailReducer>

    var body: some View {
        Form {

        }
        .navigationBarTitle(Text(store.contact.name))
    }

}

#Preview {
    NavigationStack {
        ContactDetailView(store: Store(initialState: ContactDetailReducer.State(contact: Contact(id: UUID(), name: "Blob"))) {
            ContactDetailReducer()
        })
    }
}
