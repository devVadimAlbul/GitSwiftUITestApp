// Generated using Sourcery 0.16.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// swiftlint:disable file_length
fileprivate func compareOptionals<T>(lhs: T?, rhs: T?, compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    switch (lhs, rhs) {
    case let (lValue?, rValue?):
        return compare(lValue, rValue)
    case (nil, nil):
        return true
    default:
        return false
    }
}

fileprivate func compareArrays<T>(lhs: [T], rhs: [T], compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for (idx, lhsItem) in lhs.enumerated() {
        guard compare(lhsItem, rhs[idx]) else { return false }
    }

    return true
}


// MARK: - AutoEquatable for classes, protocols, structs

// MARK: - AutoEquatable for Enums

// swiftlint:disable all


// MARK: - AutoHashable for classes, protocols, structs

// MARK: - AutoHashable for Enums

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import SwiftUI
import Combine
#elseif os(OSX)
import AppKit
#endif














class ApiGitGatewayMock: ApiGitGateway {

    //MARK: - login

    var loginAuthCallsCount = 0
    var loginAuthCalled: Bool {
        return loginAuthCallsCount > 0
    }
    var loginAuthReceivedAuth: AuthUser?
    var loginAuthReceivedInvocations: [AuthUser] = []
    var loginAuthReturnValue: AnyPublisher<UserProfile, Error>!
    var loginAuthClosure: ((AuthUser) -> AnyPublisher<UserProfile, Error>)?

    func login(auth: AuthUser) -> AnyPublisher<UserProfile, Error> {
        loginAuthCallsCount += 1
        loginAuthReceivedAuth = auth
        loginAuthReceivedInvocations.append(auth)
        return loginAuthClosure.map({ $0(auth) }) ?? loginAuthReturnValue
    }

    //MARK: - listRepositories

    var listRepositoriesUserNameCallsCount = 0
    var listRepositoriesUserNameCalled: Bool {
        return listRepositoriesUserNameCallsCount > 0
    }
    var listRepositoriesUserNameReceivedUserName: String?
    var listRepositoriesUserNameReceivedInvocations: [String] = []
    var listRepositoriesUserNameReturnValue: AnyPublisher<[GitRepository], Error>!
    var listRepositoriesUserNameClosure: ((String) -> AnyPublisher<[GitRepository], Error>)?

    func listRepositories(userName: String) -> AnyPublisher<[GitRepository], Error> {
        listRepositoriesUserNameCallsCount += 1
        listRepositoriesUserNameReceivedUserName = userName
        listRepositoriesUserNameReceivedInvocations.append(userName)
        return listRepositoriesUserNameClosure.map({ $0(userName) }) ?? listRepositoriesUserNameReturnValue
    }

}
class UserProfileGatewayMock: UserProfileGateway {

    //MARK: - loadCurrentUser

    var loadCurrentUserCallsCount = 0
    var loadCurrentUserCalled: Bool {
        return loadCurrentUserCallsCount > 0
    }
    var loadCurrentUserReturnValue: AnyPublisher<UserProfile?, Error>!
    var loadCurrentUserClosure: (() -> AnyPublisher<UserProfile?, Error>)?

    func loadCurrentUser() -> AnyPublisher<UserProfile?, Error> {
        loadCurrentUserCallsCount += 1
        return loadCurrentUserClosure.map({ $0() }) ?? loadCurrentUserReturnValue
    }

    //MARK: - login

    var loginAuthCallsCount = 0
    var loginAuthCalled: Bool {
        return loginAuthCallsCount > 0
    }
    var loginAuthReceivedAuth: AuthUser?
    var loginAuthReceivedInvocations: [AuthUser] = []
    var loginAuthReturnValue: AnyPublisher<UserProfile, Error>!
    var loginAuthClosure: ((AuthUser) -> AnyPublisher<UserProfile, Error>)?

    func login(auth: AuthUser) -> AnyPublisher<UserProfile, Error> {
        loginAuthCallsCount += 1
        loginAuthReceivedAuth = auth
        loginAuthReceivedInvocations.append(auth)
        return loginAuthClosure.map({ $0(auth) }) ?? loginAuthReturnValue
    }

}


