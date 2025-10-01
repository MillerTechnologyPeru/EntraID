//
//  TokenRequest.swift
//  EntraID
//
//  Created by Alsey Coleman Miller on 10/1/25.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import HTTP

public extension URLClient {
    
    func token(
        tenant: TenantID,
        client: String,
        secret: String,
        grantType: String = "client_credentials",
        scope: String = ".default",
        server: EntraServer = .production
    ) async throws -> EntraTokenResponse {
        let request = URLRequest(
            tenant: tenant,
            client: client,
            secret: secret,
            grantType: grantType,
            scope: scope,
            server: server
        )
        var statusCode = 200
        let decoder = JSONDecoder.entraID
        let data = try await self.request(request, decoder: decoder, statusCode: &statusCode)
        do {
            return try decoder.decode(EntraTokenResponse.self, from: data)
        } catch {
            throw EntraError.invalidResponse(error)
        }
    }
}

public struct EntraTokenResponse: Equatable, Hashable, Codable, Sendable {
    
    public let tokenType: String
    public let scope: String?
    public let expiresIn: Int
    public let extExpiresIn: Int?
    public let accessToken: String
    public let refreshToken: String?

    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case scope
        case expiresIn = "expires_in"
        case extExpiresIn = "ext_expires_in"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

internal extension URLRequest {
    
    init(
        tenant: TenantID,
        client: String,
        secret: String,
        grantType: String = "client_credentials",
        scope: String = ".default",
        server: EntraServer = .production
    ) {
        let url = EntraURL.token(tenant).url(for: server)
        self.init(url: url)
        self.httpMethod = "POST"
        self.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let scope = client + "/" + scope
        let parameters: [(key: String, value: String)] = [
            ("client_id", client),
            ("client_secret", secret),
            ("grant_type", grantType),
            ("scope", scope)
        ]
        let postString = parameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        self.httpBody = Data(postString.utf8)
    }
}
