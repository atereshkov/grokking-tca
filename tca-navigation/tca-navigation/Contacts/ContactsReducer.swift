import Foundation
import ComposableArchitecture

@Reducer
struct ContactsReducer {

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?

        var contacts: IdentifiedArrayOf<Contact> = []
    }

    enum Action {
        case addButtonTapped
        case addContact(PresentationAction<AddContactReducer.Action>)
        case deleteButtonTapped(contact: Contact)

        case destination(PresentationAction<Destination.Action>)

        enum Alert: Equatable {
            case confirmDeletion(contact: Contact)
        }
    }

    @Dependency(\.uuid) var uuid

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.destination = .addContact(
                    AddContactReducer.State(
                        contact: Contact(id: self.uuid(), name: "")
                    )
                )
                return .none
                //            case .addContact(.presented(.delegate(.cancel))):
                //                state.addContact = nil
                //                return .none
            case let .destination(.presented(.addContact(.delegate(.saveContact(contact))))):
                state.contacts.append(contact)
                //                state.addContact = nil
                return .none
            case .addContact(_):
                return .none
            case let .deleteButtonTapped(contact: contact):
                state.destination = .alert(
                    AlertState {
                        TextState("Are you sure?")
                    } actions: {
                        ButtonState(role: .destructive, action: .confirmDeletion(contact: contact)) {
                            TextState("Delete")
                        }
                    }
                )
                return .none
            case let .destination(.presented(.alert(.confirmDeletion(contact: contact)))):
                state.contacts.remove(contact)
                return .none
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

}

extension ContactsReducer {
    @Reducer(state: .equatable)
    enum Destination {
        case addContact(AddContactReducer)
        case alert(AlertState<ContactsReducer.Action.Alert>)
    }
}
