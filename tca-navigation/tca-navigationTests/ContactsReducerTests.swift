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

    func testAddFlowNonExhaustive() async {
        let store = TestStore(initialState: ContactsReducer.State()) {
            ContactsReducer()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        store.exhaustivity = .off

        await store.send(.addButtonTapped)
        await store.send(\.destination.addContact.setName, "Blob")
        await store.send(\.destination.addContact.saveButtonTapped)
        await store.skipReceivedActions()
        store.assert {
            $0.contacts = [
                Contact(id: UUID(0), name: "Blob")
            ]
            $0.destination = nil
        }
    }

    func testDeleteFlow() async {
        let store = TestStore(initialState: ContactsReducer.State(
            contacts: [
                Contact(id: UUID(0), name: "Blob"),
                Contact(id: UUID(1), name: "Blob 2")
            ]
        )) {
            ContactsReducer()
        }

        await store.send(.deleteButtonTapped(contact: Contact(id: UUID(0), name: "Blob"))) {
            $0.destination = .alert(.deleteConfirmation(contact: Contact(id: UUID(0), name: "Blob")))
        }
        await store.send(.destination(.presented(.alert(.confirmDeletion(contact: Contact(id: UUID(0), name: "Blob")))))) {
            $0.contacts.remove(id: UUID(0))
            $0.destination = nil
        }
    }

}
