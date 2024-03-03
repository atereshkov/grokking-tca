import ComposableArchitecture
import XCTest

@testable import tca_essentials

@MainActor
final class CounterFeatureTests: XCTestCase {
    func testIncrementDecrement() async {
        let store = TestStore(initialState: CounterReducer.State()) {
            CounterReducer()
        }
        
        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }

        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
    }
}
