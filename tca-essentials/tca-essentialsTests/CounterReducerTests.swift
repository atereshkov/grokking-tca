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

    func testTimer() async {
        let clock = TestClock()

        let store = TestStore(initialState: CounterReducer.State()) {
            CounterReducer()
        } withDependencies: {
            $0.continuousClock = clock
        }

        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true
        }
        await clock.advance(by: .seconds(1))
        await store.receive(\.timerTick) {
            $0.count = 1
        }
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = false
        }
    }
}
