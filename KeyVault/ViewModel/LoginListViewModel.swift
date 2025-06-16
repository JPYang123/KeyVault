import Foundation
import Combine

final class LoginListViewModel: ObservableObject {
    @Published var logins: [SecureLogin] = []
    
    // DEMO：持久化方案可改为 CoreData / FileManager + CryptoKit 等
    private let storageURL: URL = {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("logins.json")
    }()
    
    init() { load() }
    
    func load() {
        guard let data = try? Data(contentsOf: storageURL),
              let decoded = try? JSONDecoder().decode([SecureLogin].self, from: data) else { return }
        self.logins = decoded
    }
    
    func save() {
        guard let data = try? JSONEncoder().encode(logins) else { return }
        try? data.write(to: storageURL, options: .atomic)
    }
    
    func add(login: SecureLogin, password: String) {
        logins.append(login)
        try? KeychainService.shared.save(password: password, for: login.keychainKey)
        save()
    }
    
    func update(login: SecureLogin, password: String?) {
        if let idx = logins.firstIndex(where: { $0.id == login.id }) {
            logins[idx] = login
        }
        if let pwd = password {
            try? KeychainService.shared.save(password: pwd, for: login.keychainKey)
        }
        save()
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { i in
            let key = logins[i].keychainKey
            KeychainService.shared.deletePassword(for: key)
        }
        logins.remove(atOffsets: offsets)
        save()
    }
    
    /// 删除指定条目
    func delete(login: SecureLogin) {
        if let index = logins.firstIndex(where: { $0.id == login.id }) {
            delete(at: IndexSet(integer: index))
        }
    }

    // MARK: - Import & Export

    /// Create JSON data containing all login information and passwords
    func exportData() -> Data? {
        let exported: [ExportedLogin] = logins.compactMap { login in
            guard let pwd = try? KeychainService.shared.readPassword(for: login.keychainKey) else { return nil }
            return ExportedLogin(title: login.title,
                                 userName: login.userName,
                                 password: pwd,
                                 note: login.note)
        }
        return try? JSONEncoder().encode(exported)
    }

    /// Import logins from provided JSON data
    func importData(_ data: Data) {
        guard let imported = try? JSONDecoder().decode([ExportedLogin].self, from: data) else { return }
        imported.forEach { item in
            guard !logins.contains(where: { $0.title == item.title && $0.userName == item.userName }) else { return }
            let login = SecureLogin(title: item.title,
                                   userName: item.userName,
                                   keychainKey: UUID().uuidString,
                                   note: item.note)
            add(login: login, password: item.password)
        }
    }
}
