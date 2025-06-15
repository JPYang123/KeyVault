import LocalAuthentication
import SwiftUI
import Combine

final class AuthViewModel: ObservableObject {
    @Published var isUnlocked = false
    @Published var authError: Error?
    
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
}
