import Foundation
import ComposableArchitecture

@Reducer
struct ContactDetailReducer {

    @ObservableState
    struct State: Equatable {
        let contact: Contact
    }

    enum Action { }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}
