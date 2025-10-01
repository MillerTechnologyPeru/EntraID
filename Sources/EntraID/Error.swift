//
//  Error.swift
//  EntraID
//
//  Created by Alsey Coleman Miller on 10/1/25.
//

import Foundation

public enum EntraError: Error, Sendable {
    
    case authenticationRequired
    case invalidStatusCode(Int)
    case errorResponse(EntraErrorResponse)
    case invalidResponse(Error?)
}

public extension EntraError {
    
    static var invalidResponse: EntraError {
        .invalidResponse(nil)
    }
}

// MARK: - LocalizedError

#if canImport(Darwin)

extension EntraError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .authenticationRequired:
            return NSLocalizedString("Not logged in.", comment: "Not logged in.")
        case let .invalidStatusCode(statusCode):
            return String(format: NSLocalizedString("Invalid status code %@.", comment: "Invalid status code %@."), "\(statusCode)")
        case .invalidResponse:
            return NSLocalizedString("Invalid server response.", comment: "Invalid server response.")
        case let .errorResponse(errorResponse):
            return String(format: NSLocalizedString("Server responded with an error. %@.", comment: "Server responded with error. %@."), errorResponse.errorDescription)
        }
    }
}

#endif
