//
//  MockedAsyncUseCase.swift
//  PitcherAppTests
//
//  Created by Bogdan Nikolaev on 14.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

@testable
import PitcherApp
import PromiseKit

struct MockedAsyncUseCaseInput {
    let id: Int
    let message: String

    init(id: Int, message: String) {
        self.id = id
        self.message = message
    }
}

class MockedAsyncUseCase: AsyncUseCase<MockedAsyncUseCaseInput, Bool> {

    static let executionTime = 3.0
    static let failedValidationError: DomainError = .generalWithUnknownError

    struct ValidInputCredentials {
        static let id = 0
        static let message = "Test"
    }

    struct InvalidInputCredentials {
        static let id = 1
        static let message = "Test1"
    }

    override func validate(input: MockedAsyncUseCaseInput) -> DomainError? {
        if input.id == ValidInputCredentials.id && input.message == ValidInputCredentials.message {
            return nil
        }
        return MockedAsyncUseCase.failedValidationError
    }

    override func executeUseCase(resolver: Resolver<Bool>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + MockedAsyncUseCase.executionTime) {
            resolver.fulfill(true)
        }
    }
}
