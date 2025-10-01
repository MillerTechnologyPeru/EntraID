//
//  EntraURL.swift
//  EntraID
//
//  Created by Alsey Coleman Miller on 10/1/25.
//

import Foundation
import HTTPTypes

internal enum EntraURL: Equatable, Hashable, Sendable {
    
    /// `/oauth2/v2.0/token`
    case token(TenantID)
}

internal extension EntraURL {
    
    /// HTTP Method
    var method: HTTPTypes.HTTPRequest.Method {
        switch self {
        case .token:
            return .post
        }
    }
    
    /// Returns a URL for the specified environment.
    func url(for server: EntraServer) -> URL {
        return url(for: server.url)
    }
}

internal extension EntraURL {
    
    func url(for server: URL) -> URL {
        switch self {
        case let .token(id):
            return server
                .appending(id)
                .appending(.oauth2)
                .appending(.v2)
                .appending(.token)
        }
    }
}

// MARK: - CustomStringConvertible

extension EntraURL: CustomStringConvertible {
    
    public var description: String {
        self.url(for: .production).absoluteString
    }
}

// MARK: - URL Extensions

internal extension URLRequest {
    
    init(
        url: EntraURL,
        server: EntraServer = .production
    ) {
        let method = url.method.rawValue
        let url = url.url(for: server)
        self.init(url: url)
        self.httpMethod = method
    }
}

internal extension URLRequest {
    
    init<T: Encodable>(
        url: EntraURL,
        json body: T,
        server: EntraServer = .production
    ) throws {
        self.init(url: url, server: server)
        self.httpBody = try JSONEncoder.entraID.encode(body)
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}

// MARK: - Supporting Types

internal extension EntraURL {
    
    enum Path: String {
        
        case oauth2
        case v2 = "v2.0"
        case token
    }
}

internal extension URL {
    
    func appending(
        _ pathComponent: EntraURL.Path
    ) -> URL {
        appendingPathComponent(pathComponent.rawValue)
    }
    
    func appending(
        _ id: TenantID
    ) -> URL {
        appendingPathComponent(id.rawValue)
    }
}
