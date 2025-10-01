//
//  String.swift
//  EntraID
//
//  Created by Alsey Coleman Miller on 10/1/25.
//

internal extension String {
    
    var isASCII: Bool {
        self.utf8.allSatisfy { $0 & 0x80 == 0 }
    }
}
