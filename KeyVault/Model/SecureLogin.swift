import Foundation
import SwiftUI

struct SecureLogin: Identifiable, Hashable, Codable {
    var id: UUID = .init()
    var title: String
    var userName: String
    /// Keychain 中保存密码时使用的唯一 service+account 组合
    var keychainKey: String
    var note: String?
}
