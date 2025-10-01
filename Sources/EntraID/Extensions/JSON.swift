//
//  JSON.swift
//  EntraID
//
//  Created by Alsey Coleman Miller on 10/1/25.
//

import Foundation

internal extension JSONDecoder {
    
    static var entraID: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

internal extension JSONEncoder {
    
    static var entraID: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}
