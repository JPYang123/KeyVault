import Foundation

struct ExportedLogin: Codable {
    var title: String
    var userName: String
    var password: String
    var note: String?
    /// Optional icon name for backward compatibility with older exports
    var iconName: String?
}
