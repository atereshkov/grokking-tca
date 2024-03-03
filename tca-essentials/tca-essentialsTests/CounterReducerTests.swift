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

    func testNumberFactStruct() async {
        let store = TestStore(initialState: CounterReducer.State()) {
            CounterReducer()
        } withDependencies: {
            $0.numberFact.fetch = { "\($0) is a good number." }
        }

        await store.send(.factButtonTapped) {
            $0.isLoading = true
        }
        await store.receive(\.factResponse) {
            $0.isLoading = false
            $0.fact = "0 is a good number."
        }
    }

    /*
    func testNumberFactProtocol() async {
        let store = TestStore(initialState: CounterReducer.State()) {
            CounterReducer()
        } withDependencies: {
            $0.numberFactProtocol = MockNumberNetworkClient("0 is a good number.")
        }

        await store.send(.factButtonTapped) {
            $0.isLoading = true
        }
        await store.receive(\.factResponse) {
            $0.isLoading = false
            $0.fact = "0 is a good number."
        }
    }
    */
}

final class MockNumberNetworkClient: NumberNetworkClient {

    var fetchResult: String

    init(_ fetchResult: String) {
        self.fetchResult = fetchResult
    }

    override func fetch(_ number: Int) async throws -> String {
        return fetchResult
    }
}
