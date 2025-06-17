import Foundation
import SwiftUI

struct SecureLogin: Identifiable, Hashable, Codable {
    var id: UUID = .init()
    var title: String
    var userName: String
    /// Keychain 中保存密码时使用的唯一 service+account 组合
    var keychainKey: String
    var note: String?
    /// SF Symbol name used as icon for this login
     var iconName: String = LoginIcon.web.rawValue

     enum CodingKeys: String, CodingKey {
         case id, title, userName, keychainKey, note, iconName
     }

     init(id: UUID = .init(), title: String, userName: String, keychainKey: String, note: String? = nil, iconName: String = LoginIcon.web.rawValue) {
         self.id = id
         self.title = title
         self.userName = userName
         self.keychainKey = keychainKey
         self.note = note
         self.iconName = iconName
     }

     init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         id = try container.decode(UUID.self, forKey: .id)
         title = try container.decode(String.self, forKey: .title)
         userName = try container.decode(String.self, forKey: .userName)
         keychainKey = try container.decode(String.self, forKey: .keychainKey)
         note = try container.decodeIfPresent(String.self, forKey: .note)
         iconName = try container.decodeIfPresent(String.self, forKey: .iconName) ?? LoginIcon.web.rawValue
     }
 }

 /// Predefined set of icons that users can choose from
enum LoginIcon: String, CaseIterable, Identifiable, Codable {
    case web = "globe"
    case shopping = "cart"
    case amusement = "gamecontroller"
    case exercise = "figure.walk"
    case finance = "dollarsign.circle"
    case news = "newspaper"
    case hobby = "paintpalette"
    case sports = "sportscourt"
    case social = "message"
    
    var id: String { rawValue }
}
