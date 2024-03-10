import ComposableArchitecture

@Reducer
struct AddContactReducer {

    @ObservableState
    struct State: Equatable {
        var contact: Contact
    }

    enum Action {
        case cancelButtonTapped
        case saveButtonTapped
        case setName(String)

        case delegate(Delegate)

        enum Delegate: Equatable {
//            case cancel
            case saveContact(Contact)
        }
    }

    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
//                return .send(.delegate(.cancel))
                return .run { _ in await self.dismiss() }
            case .saveButtonTapped:
//                return .send(.delegate(.saveContact(state.contact)))
                return .run { [contact = state.contact] send in
                    await send(.delegate(.saveContact(contact)))
                    await self.dismiss()
                }
            case .setName(let name):
                state.contact.name = name
                return .none
            case .delegate:
                return .none
            }
        }
    }
}
