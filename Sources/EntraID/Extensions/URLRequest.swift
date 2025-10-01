//
//  URLRequest.swift
//  EntraID
//
//  Created by Alsey Coleman Miller on 10/1/25.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import HTTPTypes

internal extension URLRequest {
    
    mutating func setFormURLEncoded(_ queryItems: [URLQueryItem]) {
        self.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        // https://url.spec.whatwg.org/#concept-urlencoded-serializer
        let output = queryItems.lazy
            .map { ($0.name, $0.value ?? "") }
            .map { ($0.formURLEncoded(), $1.formURLEncoded()) }
            .map { "\($0)=\($1)" }
            .joined(separator: "&")
        let data = output.data(using: .utf8)
        self.httpBody = data
        if let contentLength = data?.count {
            self.setValue(String(contentLength), forHTTPHeaderField: "Content-Length")
        }
    }
}

internal extension URLClient {
    
    func request<Request>(
        url: URL,
        method: HTTPTypes.HTTPRequest.Method,
        body: Request,
        encoder: JSONEncoder = .entraID,
        decoder: JSONDecoder = .entraID,
        authorization authorizationToken: AuthorizationToken? = nil,
        statusCode: inout Int,
        headers: [String: String] = [:]
    ) async throws where Request: Encodable {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = try encoder.encode(body)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try await request(
            &urlRequest,
            decoder: decoder,
            authorization: authorizationToken,
            statusCode: &statusCode,
            headers: headers
        )
        guard data.isEmpty else {
            throw EntraError.invalidResponse
        }
    }
    
    func request<Response>(
        url: URL,
        method: HTTPTypes.HTTPRequest.Method,
        response responseType: Response.Type,
        encoder: JSONEncoder = .entraID,
        decoder: JSONDecoder = .entraID,
        authorization authorizationToken: AuthorizationToken? = nil,
        statusCode: inout Int,
        headers: [String: String] = [:]
    ) async throws -> Response where Response: Decodable {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        let data = try await request(
            &urlRequest,
            decoder: decoder,
            authorization: authorizationToken,
            statusCode: &statusCode,
            headers: headers
        )
        do {
            return try decoder.decode(responseType, from: data)
        } catch {
            throw EntraError.invalidResponse(error)
        }
    }
    
    func request<Request, Response>(
        url: URL,
        method: HTTPTypes.HTTPRequest.Method,
        body: Request,
        response responseType: Response.Type,
        encoder: JSONEncoder = .entraID,
        decoder: JSONDecoder = .entraID,
        authorization authorizationToken: AuthorizationToken? = nil,
        statusCode: inout Int,
        headers: [String: String] = [:]
    ) async throws -> Response where Request: Encodable, Response: Decodable {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = try encoder.encode(body)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try await request(
            &urlRequest,
            decoder: decoder,
            authorization: authorizationToken,
            statusCode: &statusCode,
            headers: headers
        )
        do {
            return try decoder.decode(responseType, from: data)
        } catch {
            throw EntraError.invalidResponse(error)
        }
    }
    
    @discardableResult
    func request(
        _ urlRequest: inout URLRequest,
        decoder: JSONDecoder,
        authorization authorizationToken: AuthorizationToken? = nil,
        statusCode: inout Int,
        headers: [String: String] = [:]
    ) async throws -> Data {
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        if let token = authorizationToken {
            urlRequest.setAuthorization(token)
        }
        for (header, value) in headers.sorted(by: { $0.key < $1.key }) {
            urlRequest.addValue(value, forHTTPHeaderField: header)
        }
        return try await request(urlRequest, decoder: decoder, statusCode: &statusCode)
    }
    
    @discardableResult
    func request(
        _ urlRequest: URLRequest,
        decoder: JSONDecoder,
        statusCode: inout Int
    ) async throws -> Data {
        let (data, urlResponse) = try await self.data(for: urlRequest)
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            assertionFailure("Invalid response type \(urlResponse)")
            throw Foundation.URLError(.unknown)
        }
        let expectedStatusCode = statusCode
        statusCode = httpResponse.statusCode
        guard statusCode == expectedStatusCode else {
            if data.isEmpty == false, let decodedResponse = try? decoder.decode(EntraErrorResponse.self, from: data) {
                throw EntraError.errorResponse(decodedResponse)
            } else {
                throw EntraError.invalidStatusCode(httpResponse.statusCode)
            }
        }
        return data
    }
}
