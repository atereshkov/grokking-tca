import ComposableArchitecture
import XCTest

@testable import tca_essentials

@MainActor
final class AppReducerTests: XCTestCase {
    func testIncrementDecrementFirstTab() async {
        let store = TestStore(initialState: AppReducer.State()) {
            AppReducer()
        }

        await store.send(\.tab1.incrementButtonTapped) {
            $0.tab1.count = 1
        }
        await store.send(\.tab1.decrementButtonTapped) {
            $0.tab1.count = 0
        }
    }

    func testIncrementDecrementSecondTab() async {
        let store = TestStore(initialState: AppReducer.State()) {
            AppReducer()
        }

        await store.send(\.tab2.incrementButtonTapped) {
            $0.tab2.count = 1
        }
        await store.send(\.tab2.decrementButtonTapped) {
            $0.tab2.count = 0
        }
    }
}
