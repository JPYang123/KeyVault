import Foundation
import Security

/// 对 Keychain 进行简易封装
final class KeychainService {
    static let shared = KeychainService()
    private init() {}
    
    func save(password: String, for key: String) throws {
        let data = password.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String           : kSecClassGenericPassword,
            kSecAttrService as String     : "com.yourcompany.ipassword", // 自定义
            kSecAttrAccount as String     : key,
            kSecValueData as String       : data,
            kSecAttrAccessible as String  : kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
        ]
        SecItemDelete(query as CFDictionary)                 // 先删除旧值
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw NSError(domain: "Keychain", code: Int(status)) }
    }
    
    func readPassword(for key: String) throws -> String {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : "com.yourcompany.ipassword",
            kSecAttrAccount as String : key,
            kSecReturnData as String  : true,
            kSecMatchLimit as String  : kSecMatchLimitOne
        ]
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess,
              let data = item as? Data,
              let pwd  = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "Keychain", code: Int(status))
        }
        return pwd
    }
    
    func deletePassword(for key: String) {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : "com.yourcompany.ipassword",
            kSecAttrAccount as String : key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
