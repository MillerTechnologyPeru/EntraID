//
//  TenantID.swift
//  EntraID
//
//  Created by Alsey Coleman Miller on 10/1/25.
//

import Foundation

/// Microsoft Entra Tenant ID
public struct TenantID: Codable, Equatable, Hashable, Sendable {
    
    internal let uuid: UUID
    
    public init(_ uuid: UUID) {
        self.uuid = uuid
    }
}

public extension UUID {
    
    init(_ id: TenantID) {
        self = id.uuid
    }
}

public extension URL {
    
    init(oauth tenantID: TenantID, server: EntraServer = .production) {
        self = EntraURL.token(tenantID).url(for: server)
    }
}

// MARK: - CustomStringConvertible

extension TenantID: RawRepresentable {
    
    public init?(rawValue: String) {
        guard let uuid = UUID(uuidString: rawValue) else {
            return nil
        }
        self.init(uuid)
    }
    
    public var rawValue: String {
        uuid.uuidString.lowercased()
    }
}

// MARK: - CustomStringConvertible

extension TenantID: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        rawValue
    }
    
    public var debugDescription: String {
        rawValue
    }
}
