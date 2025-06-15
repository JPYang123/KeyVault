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
}
