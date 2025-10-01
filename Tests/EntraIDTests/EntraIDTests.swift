import Foundation
import Testing
@testable import EntraID

@Suite
struct EntraIDTests {
    
    @Test
    func url() {
        #expect(EntraURL.token(TenantID(UUID(uuidString: "3010CEEC-6FE9-47D3-96A0-2A5AABAD89EA")!)).description == "https://login.microsoftonline.com/3010ceec-6fe9-47d3-96a0-2a5aabad89ea/oauth2/v2.0/token")
    }
}
