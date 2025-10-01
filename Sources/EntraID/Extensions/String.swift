//
//  String.swift
//  EntraID
//
//  Created by Alsey Coleman Miller on 10/1/25.
//

import Foundation

internal extension String {
    
    func formURLEncoded() -> String {
        return self
            // Force-unwrapping because only known failure case is unpaired surrogate
            .addingPercentEncoding(withAllowedCharacters: Self.formURLEncodedAllowedCharacters)!
            .replacingOccurrences(of: " ", with: "+")
    }
}

internal extension String {
    
    static let formURLEncodedAllowedCharacters: CharacterSet = {
        typealias c = UnicodeScalar
        
        // https://url.spec.whatwg.org/#urlencoded-serializing
        var allowed = CharacterSet()
        allowed.insert(c(0x2A))
        allowed.insert(charactersIn: c(0x2D)...c(0x2E))
        allowed.insert(charactersIn: c(0x30)...c(0x39))
        allowed.insert(charactersIn: c(0x41)...c(0x5A))
        allowed.insert(c(0x5F))
        allowed.insert(charactersIn: c(0x61)...c(0x7A))
        
        // and we'll deal with ` ` later…
        allowed.insert(" ")
        
        return allowed
    }()
}
