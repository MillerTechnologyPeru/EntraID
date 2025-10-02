//
//  JWT.swift
//  EntraID
//
//  Created by Alsey Coleman Miller on 10/1/25.
//

import Foundation

// MARK: - JWT

public struct JSONWebToken <Header, Body> {
    
    public let header: Header
    
    public let body: Body
    
    public let signature: String
}

extension JSONWebToken where Header: Decodable, Body: Decodable {
    
    public init?(rawValue jwt: String) {
        let parts = jwt.components(separatedBy: ".")
        // parse string
        guard parts.count == 3,
              let headerData = Data(base64URLEncoded: parts[0]),
              let bodyData = Data(base64URLEncoded: parts[1]) else {
            return nil
        }
        // decode JSON parts
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            self.header = try decoder.decode(Header.self, from: headerData)
            self.body = try decoder.decode(Body.self, from: bodyData)
        }
        catch {
            return nil
        }
        
        self.signature = parts[2]
    }
}

extension JSONWebToken: Equatable where Header: Equatable, Body: Equatable { }

extension JSONWebToken: Hashable where Header: Hashable, Body: Hashable { }

extension JSONWebToken: Sendable where Header: Sendable, Body: Sendable { }
