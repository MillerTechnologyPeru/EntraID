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
import OAuth

public typealias EntraAuthorizationToken = OAuth.AuthorizationToken<EntraAuthorizationTokenHeader, EntraAuthorizationTokenPayload>

public struct EntraAuthorizationTokenHeader: Equatable, Hashable, Codable, Sendable {
    
    public let type: String
    
    public let key: String
    
    public let algorithm: String
    
    public let x509Fingerprint: String?
    
    enum CodingKeys: String, CodingKey {
        
        case type               = "typ"
        case key                = "kid"
        case algorithm          = "alg"
        case x509Fingerprint    = "x5t"
    }
}

public struct EntraAuthorizationTokenPayload: Equatable, Hashable, Codable, Sendable {
    
    public let audience: String
    public let issuer: String
    public let issuedAt: Date
    public let notBefore: Date
    public let expiration: Date
    public let aio: String
    public let appId: String
    public let appIdAcr: String
    public let identityProvider: String
    public let objectId: String
    public let refreshHandle: String
    public let subject: String
    public let tenantId: TenantID
    public let uti: String
    public let version: String
    public let federationToken: String
    
    enum CodingKeys: String, CodingKey {
        case audience = "aud"
        case issuer = "iss"
        case issuedAt = "iat"
        case notBefore = "nbf"
        case expiration = "exp"
        case aio
        case appId = "appid"
        case appIdAcr = "appidacr"
        case identityProvider = "idp"
        case objectId = "oid"
        case refreshHandle = "rh"
        case subject = "sub"
        case tenantId = "tid"
        case uti
        case version = "ver"
        case federationToken = "xms_ftd"
    }
}
