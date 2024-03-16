import ComposableArchitecture
import XCTest

@testable import tca_navigation

@MainActor
final class ContactsReducerTests: XCTestCase {

    func testAddFlow() async {
        let store = TestStore(initialState: ContactsReducer.State()) {
            ContactsReducer()
        } withDependencies: {
            $0.uuid = .incrementing
        }

        await store.send(.addButtonTapped) {
            $0.destination = .addContact(
                AddContactReducer.State(contact: Contact(id: UUID(0), name: ""))
            )
        }
        await store.send(\.destination.addContact.setName, "Blob") {
            $0.destination?.addContact?.contact.name = "Blob"
        }
        await store.send(\.destination.addContact.saveButtonTapped)
        await store.receive(\.destination.addContact.delegate.saveContact, Contact(id: UUID(0), name: "Blob")) {
            $0.contacts = [
                Contact(id: UUID(0), name: "Blob")
            ]
        }
        await store.receive(\.destination.dismiss) {
            $0.destination = nil
        }
    }

}
