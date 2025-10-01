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
        return decoder
    }
}

internal extension JSONEncoder {
    
    static var entraID: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        return encoder
    }
}
