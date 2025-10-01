//
//  HTTPClient.swift
//  EntraID
//
//  Created by Alsey Coleman Miller on 10/1/25.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import HTTPTypes
#if canImport(HTTPTypesFoundation)
import HTTPTypesFoundation
#endif

public protocol HTTPClient {
    
    associatedtype HTTPError: Error
    
    func data(
        for request: HTTPRequest
    ) async throws(HTTPError) -> (Data, HTTPResponse)
}

#if canImport(HTTPTypesFoundation)
extension URLClient where Self: HTTPClient, Self.HTTPError == Self.URLError, Self.URLError == Foundation.URLError {
    
    public func data(
        for request: HTTPRequest
    ) async throws(URLError) -> (Data, HTTPResponse) {
        guard let urlRequest = URLRequest(httpRequest: request) else {
            assertionFailure()
            throw URLError(.unknown)
        }
        let (data, urlResponse) = try await self.data(for: urlRequest)
        guard let response = (urlResponse as? HTTPURLResponse)?.httpResponse else {
            assertionFailure()
            throw URLError(.unknown)
        }
        return (data, response)
    }
}
#endif
