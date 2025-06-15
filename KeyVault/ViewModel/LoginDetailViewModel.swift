import Foundation

final class LoginDetailViewModel: ObservableObject {
    @Published var login: SecureLogin
    @Published var password: String = "••••••"
    
    init(login: SecureLogin) {
        self.login = login
    }
    
    func reveal() {
        password = (try? KeychainService.shared.readPassword(for: login.keychainKey)) ?? "读取失败"
    }
}
