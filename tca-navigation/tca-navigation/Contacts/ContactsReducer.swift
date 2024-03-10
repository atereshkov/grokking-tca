import Foundation
import ComposableArchitecture

@Reducer
struct ContactsReducer {

    @ObservableState
    struct State: Equatable {
        @Presents var addContact: AddContactReducer.State?
        @Presents var alert: AlertState<Action.Alert>?

        var contacts: IdentifiedArrayOf<Contact> = []
    }

    enum Action {
        case addButtonTapped
        case addContact(PresentationAction<AddContactReducer.Action>)
        case deleteButtonTapped(contact: Contact)

        case alert(PresentationAction<Alert>)

        enum Alert: Equatable {
            case confirmDeletion(contact: Contact)
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addContact = AddContactReducer.State(contact: Contact(id: UUID(), name: ""))
                return .none
//            case .addContact(.presented(.delegate(.cancel))):
//                state.addContact = nil
//                return .none
            case let .addContact(.presented(.delegate(.saveContact(contact)))):
                state.contacts.append(contact)
//                state.addContact = nil
                return .none
            case .addContact(_):
                return .none
            case let .deleteButtonTapped(contact: contact):
                state.alert = AlertState {
                    TextState("Are you sure?")
                } actions: {
                    ButtonState(role: .destructive, action: .confirmDeletion(contact: contact)) {
                        TextState("Delete")
                    }
                }
                return .none
            case let .alert(.presented(.confirmDeletion(contact: contact))):
                state.contacts.remove(contact)
                return .none
            case .alert(_):
                return .none
            }
        }
        .ifLet(\.$addContact, action: \.addContact) { AddContactReducer() }
        .ifLet(\.$alert, action: \.alert)
    }

}
