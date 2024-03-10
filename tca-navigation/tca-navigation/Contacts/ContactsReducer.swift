import Foundation
import ComposableArchitecture

@Reducer
struct ContactsReducer {

    @ObservableState
    struct State: Equatable {
        @Presents var addContact: AddContactReducer.State?

        var contacts: IdentifiedArrayOf<Contact> = []
    }

    enum Action {
        case addButtonTapped
        case addContact(PresentationAction<AddContactReducer.Action>)
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
            }
        }
        .ifLet(\.$addContact, action: \.addContact) {
            AddContactReducer()
        }
    }

}
