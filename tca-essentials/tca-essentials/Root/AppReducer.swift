import ComposableArchitecture
import Foundation

@Reducer
struct AppReducer {

    struct State: Equatable {
        var tab1 = CounterReducer.State()
        var tab2 = CounterReducer.State()
    }

    enum Action {
        case tab1(CounterReducer.Action)
        case tab2(CounterReducer.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.tab1, action: \.tab1) {
            CounterReducer()
        }
        Scope(state: \.tab2, action: \.tab2) {
            CounterReducer()
        }
        Reduce { state, action in
            // Core logic of the app feature
            return .none
        }
    }
}
