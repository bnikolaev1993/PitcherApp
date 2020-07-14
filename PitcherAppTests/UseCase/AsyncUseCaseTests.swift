//
//  AsyncUseCaseTests.swift
//  PitcherAppTests
//
//  Created by Bogdan Nikolaev on 14.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

@testable
import PitcherApp
import XCTest

class AsyncUseCaseTests: XCTestCase {

    var sut: MockedAsyncUseCase?
    let validUcInput = MockedAsyncUseCaseInput(id: MockedAsyncUseCase.ValidInputCredentials.id, message: MockedAsyncUseCase.ValidInputCredentials.message)
    let invalidUcInput = MockedAsyncUseCaseInput(id: MockedAsyncUseCase.InvalidInputCredentials.id, message: MockedAsyncUseCase.InvalidInputCredentials.message)

    func testUseCaseFailsValidation() {
        let toWait = XCTestExpectation()
        sut = MockedAsyncUseCase(input: invalidUcInput)
        sut?.act().done { _ in
            XCTFail("Shouldn't pass the test")
            toWait.fulfill()
        }.catch { error in
            guard let error = error as? DomainError else {
                XCTFail("Error shouldn't be nil")
                return
            }
            XCTAssert(error == MockedAsyncUseCase.failedValidationError, "Wrong error message received: \(error.self)")
            toWait.fulfill()
        }
        wait(for: [toWait], timeout: 20)
    }

    func testUseCasePassesValidation() {
        let toWait = XCTestExpectation()
        sut = MockedAsyncUseCase(input: validUcInput)
        sut?.act().done { isFulfilled in
            XCTAssertTrue(isFulfilled, "Promise should be fulfilled")
            toWait.fulfill()
        }.catch { error in
            XCTFail("Shouldn't fail the test: \(error.self)")
        }
        wait(for: [toWait], timeout: 20)
    }

    func testUseCasePassesTimeout() {
        let toWait = XCTestExpectation()
        sut = MockedAsyncUseCase(input: validUcInput, timeoutSettings: .timeOut(timeout: TimeInterval(MockedAsyncUseCase.executionTime + 1)))
        sut?.act().done { isFulfilled in
            XCTAssertTrue(isFulfilled, "Promise should be fulfilled")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                toWait.fulfill()
            }
        }.catch { error in
            XCTFail("Shouldn't fail the test: \(error.self)")
            toWait.fulfill()
        }
        wait(for: [toWait], timeout: 20)
    }

    func testUseCaseFailsTimeout() {
        let toWait = XCTestExpectation()
        sut = MockedAsyncUseCase(input: validUcInput, timeoutSettings: .timeOut(timeout: TimeInterval(MockedAsyncUseCase.executionTime - 1)))
        sut?.act().done { isFulfilled in
            XCTAssertFalse(isFulfilled, "The promise shouldn't be fulfilled")
            toWait.fulfill()
        }.catch { error in
            guard let error = error as? DomainError else {
                XCTFail("Error shouldn't be nil")
                return
            }
            XCTAssertTrue(error == .useCaseTimeOut, "Wrong error message received: \(error.self)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                toWait.fulfill()
            }
        }
        wait(for: [toWait], timeout: 20)
    }
}
