//
//  ErrorResponse.swift
//  EntraID
//
//  Created by Alsey Coleman Miller on 10/1/25.
//

import Foundation

/// Microsoft Entra Error Response
public struct EntraErrorResponse: Equatable, Hashable, Codable, Sendable {
    
    public let error: String
    public let errorDescription: String
    public let errorCodes: [Int]
    public let timestamp: Date
    public let traceId: String
    public let correlationId: String

    enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
        case errorCodes = "error_codes"
        case timestamp
        case traceId = "trace_id"
        case correlationId = "correlation_id"
    }
}
