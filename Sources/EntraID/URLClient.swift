//
//  URLClient.swift
//  EntraID
//
//  Created by Alsey Coleman Miller on 10/1/25.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// URL Client
public protocol URLClient {
    
    associatedtype URLError: Error
    
    func data(
        for request: URLRequest
    ) async throws(URLError) -> (Data, URLResponse)
}
