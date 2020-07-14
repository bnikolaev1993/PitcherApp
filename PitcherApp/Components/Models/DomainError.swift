//
//  DomainError.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 13.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import Foundation

public enum DomainError: Error {
    // General
    case generalWithError(_: Error)
    case generalWithMessage(_ : String)
    case generalWithUnknownError
    case generalWithTimeout
    case generalWithInvalidResponse
    case generalWithDoNothing

    // UseCase
    case useCaseTimeOut

    // Video & Audio
    case videoIsNotCopied
    case presetsAreNotExtracted
}

extension DomainError: Equatable {
  public static func == (lhs: DomainError, rhs: DomainError) -> Bool {
        switch (lhs, rhs) {
        case (.generalWithError, .generalWithError),
             (generalWithMessage, .generalWithMessage),
             (.generalWithUnknownError, .generalWithUnknownError),
             (.generalWithTimeout, .generalWithTimeout),
             (.generalWithInvalidResponse, .generalWithInvalidResponse),
             (.generalWithDoNothing, .generalWithDoNothing),
             (.useCaseTimeOut, .useCaseTimeOut),
             (.videoIsNotCopied, .videoIsNotCopied),
             (.presetsAreNotExtracted, .presetsAreNotExtracted):
            return true
        default:
            return false
        }
    }
}
