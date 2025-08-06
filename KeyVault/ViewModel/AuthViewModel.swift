import Foundation
import LocalAuthentication
import SwiftUI
import Combine

final class AuthViewModel: ObservableObject {
    @Published var isUnlocked = false
    @Published var authError: Error?
    @Published var hasPassword = false

    private let passwordKey = "masterPassword"

    init() {
        hasPassword = (try? KeychainService.shared.readPassword(for: passwordKey)) != nil
    }
    
    func unlock() {
        let context = LAContext()
        var error: NSError?
        let reason = "使用 Face ID 解锁您的密码库"
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: reason) { [weak self] success, err in
                DispatchQueue.main.async {
                    self?.isUnlocked = success
                    self?.authError = err
                }
            }
        } else {
            // 回退至系统密码
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] success, err in
                DispatchQueue.main.async {
                    self?.isUnlocked = success
                    self?.authError = err
                }
            }
        }
    }
    
    func login(with password: String) {
            if verify(password: password) {
                isUnlocked = true
                authError = nil
            } else {
                isUnlocked = false
                authError = NSError(domain: "Auth", code: 1, userInfo: [NSLocalizedDescriptionKey: "Incorrect Password"])
            }
        }

    func setPassword(_ password: String) {
        try? KeychainService.shared.save(password: password, for: passwordKey)
        hasPassword = true
    }
    
    func changePassword(old: String, new: String) -> Bool {
        guard verify(password: old) else { return false }
        try? KeychainService.shared.save(password: new, for: passwordKey)
        return true
    }
    
    func verify(password: String) -> Bool {
        guard let stored = try? KeychainService.shared.readPassword(for: passwordKey) else { return false }
        return stored == password
    }
}
