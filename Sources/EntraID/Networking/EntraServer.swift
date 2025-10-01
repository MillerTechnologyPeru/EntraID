//
//  EntraServer.swift
//  EntraID
//
//  Created by Alsey Coleman Miller on 10/1/25.
//

import Foundation

/// Microsoft Entra ID Server
public enum EntraServer: Sendable {
    
    /// Production Environment
    case production
}

public extension EntraServer {
    
    var url: URL {
        switch self {
        case .production:
            return URL(string: "https://login.microsoftonline.com")!
        }
    }
}
