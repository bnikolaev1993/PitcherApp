//
//  UseCase.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 13.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import Foundation
import PromiseKit

enum UseCaseTimeOutSettings {
    case defaultTimeOut
    case timeOut(timeout: TimeInterval)
    case noTimeOut
}

class UseCase<I, O> {
    typealias InputType = I
    typealias ReturnType = O

    let input: InputType

    required init(input: InputType) {
        self.input = input
        self.addDomainErrorInterceptors()
    }

    func addDomainErrorInterceptors() { }
}

enum SyncUseCaseResult<O> {
    case success(value: O)
    case failure(error: DomainError)
}

class SyncUseCase<I, O>: UseCase<I, O> {

    @discardableResult
    final func act() -> SyncUseCaseResult<ReturnType> {
        let (res, err) = executeUseCase()
        if let res = res {
            return SyncUseCaseResult.success(value: res)
        } else if let err = err {
            return SyncUseCaseResult.failure(error: err)
        } else {
            return SyncUseCaseResult.failure(error: DomainError.generalWithUnknownError)
        }
    }

    func executeUseCase() -> (ReturnType?, DomainError?) {
        return customExecuteUseCase()
    }

    func customExecuteUseCase() -> (ReturnType?, DomainError?) {
        fatalError("If should custom execute, you must override this in subclass")
    }

}

class AsyncUseCase<I, O>: UseCase<I, O> {

    // Set the max allowed time duration and the error type that will be sent if the time limit is reached- if needed.
    fileprivate var timeoutSettings: UseCaseTimeOutSettings

    fileprivate var (promise, resolver) = Promise<ReturnType>.pending()
    fileprivate var retainCycle: AsyncUseCase<I, O>?

    init(input: InputType, timeoutSettings: UseCaseTimeOutSettings) {
        self.timeoutSettings = timeoutSettings
        super.init(input: input)
        retainCycle = self
    }

    required convenience init(input: InputType) {
        self.init(input: input, timeoutSettings: .defaultTimeOut)
    }

    fileprivate func applyTimeOutSettngs(_ resolver: Resolver<O>) {
        switch timeoutSettings {
        case .timeOut(timeout: let interval):
            setupTimeout(with: Int(interval), resolver: resolver)
        case .defaultTimeOut:
            setupTimeout(with: 10, resolver: resolver)
        case .noTimeOut:
            break
        }
    }

    /// Start UserCase execution without any UseCaseNotification notification about it status or errors
    ///
    /// - Returns: Promise<ReturnType>
    @discardableResult
    final func act() -> Promise<ReturnType> {

        promise = Promise<ReturnType> { resolver in
            if let validationError = validate(input: input) {
                handleReject(seal: resolver, error: validationError)
                return
            }
            applyTimeOutSettngs(resolver)
            executeUseCase(resolver: resolver)
        }

        return promise
    }

    /// Start UserCase execution with  .userCaseError notified if any error occour
    ///
    /// - Returns: Promise<ReturnType>

    final func getTimeoutSettings() -> UseCaseTimeOutSettings {
        return self.timeoutSettings
    }

    func customExecuteUseCase(resolver: Resolver<ReturnType>) { }

    func executeUseCase(resolver: Resolver<ReturnType>) {
        customExecuteUseCase(resolver: resolver)
    }

    func validate(input: InputType) -> DomainError? {
        return nil
    }

    func setupTimeout(with seconds: Int, resolver: Resolver<O>) {
        after(DispatchTimeInterval.seconds(Int(seconds))).done { [weak self] in
            if let isPending = self?.promise.isPending, isPending {
                self?.handleTimeOut(seal: resolver)
            }
        }
    }

    func handleFullfill(seal: Resolver<O>, result: O) {
        if promise.isPending {
            seal.fulfill(result)
            retainCycle = nil
        }
    }

    func handleReject(seal: Resolver<O>, error: Error) {
        if promise.isPending {
            seal.reject(error)
            retainCycle = nil
        }
    }

    func handleTimeOut(seal: Resolver<O>) {
        if retainCycle != nil {
            self.handleReject(seal: seal, error: DomainError.useCaseTimeOut)
        }
    }
}
