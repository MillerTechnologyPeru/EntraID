//
//  AuthorizationToken.swift
//  EntraID
//
//  Created by Alsey Coleman Miller on 10/1/25.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import HTTPTypes

/// Microsoft Entra ID Authorization Token
public struct AuthorizationToken: Equatable, Hashable, RawRepresentable, Codable, Sendable {
    
    public let rawValue: String
    
    internal let jwt: JSONWebToken<Header, Payload>
    
    public init?(rawValue: String) {
        guard let jwt = JSONWebToken<Header, Payload>(rawValue: rawValue) else {
            return nil
        }
        self.rawValue = rawValue
        self.jwt = jwt
    }
}

// MARK: - CustomStringConvertible

extension AuthorizationToken: CustomStringConvertible {
    
    public var description: String {
        rawValue
    }
}

// MARK: - HTTP Header

public extension URLRequest {
    
    mutating func setAuthorization(_ token: AuthorizationToken) {
        let field = HTTPField(authorization: token)
        self.setValue(field.value, forHTTPHeaderField: field.name.rawName)
    }
}

public extension HTTPField {
    
    init(authorization token: AuthorizationToken) {
        let value = "Bearer " + token.rawValue
        self.init(name: .authorization, value: value)
    }
}

// MARK: - Supporting Types

public extension AuthorizationToken {
    
    var payload: Payload {
        jwt.body
    }
}

public extension AuthorizationToken {
    
    struct Header: Equatable, Hashable, Codable, Sendable {
        
        public let type: String
        
        public let key: String
        
        public let algorithm: String
        
        enum CodingKeys: String, CodingKey {
            case type           = "typ"
            case key            = "kid"
            case algorithm      = "alg"
        }
    }
    
    struct Payload: Equatable, Hashable, Codable, Sendable {
        
        public let sub: String
        public let cts: String
        public let authLevel: Int
        public let auditTrackingId: String
        public let subname: String
        public let iss: String
        public let tokenName: String
        public let tokenType: String
        public let authGrantId: String
        public let aud: String
        public let nbf: Int
        public let grantType: String
        public let scope: [String]
        public let authTime: Int
        public let realm: String
        public let exp: Int
        public let iat: Int
        public let expiresIn: Int
        public let jti: String
        public let externalId: String
        
        enum CodingKeys: String, CodingKey {
            case sub
            case cts
            case authLevel = "auth_level"
            case auditTrackingId = "auditTrackingId"
            case subname
            case iss
            case tokenName = "tokenName"
            case tokenType = "token_type"
            case authGrantId = "authGrantId"
            case aud
            case nbf
            case grantType = "grant_type"
            case scope
            case authTime = "auth_time"
            case realm
            case exp
            case iat
            case expiresIn = "expires_in"
            case jti
            case externalId = "external_id"
        }
    }
}
