//
//  TokenRequest.swift
//  EntraID
//
//  Created by Alsey Coleman Miller on 10/1/25.
//

import Foundation
import HTTP
import OAuth

public extension URLClient {
    
    func oauthToken(
        tenant: TenantID,
        clientId: String,
        clientSecret: String,
        scope: String,
        server: EntraServer = .production
    ) async throws -> TokenResponse<EntraAuthorizationTokenHeader, EntraAuthorizationTokenPayload> {
        let url = URL(oauth: tenant, server: .production)
        let request = TokenRequest(
            clientId: clientId,
            clientSecret: clientSecret,
            audience: nil,
            grantType: .clientCredentials,
            scope: scope
        )
        return try await self.oauthToken(request, url: url, formEncoded: true)
    }
}
