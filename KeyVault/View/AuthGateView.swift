// AuthGateView.swift
import SwiftUI

struct AuthGateView: View {
    @StateObject private var auth = AuthViewModel()
    @State private var password = ""
    var body: some View {
        Group {
            if auth.isUnlocked {
                IndexedLoginListView()
                    .environmentObject(auth)
            } else {
                VStack(spacing: 32) {
                    Spacer()
                    Image(systemName: "lock.fill")
                        .font(.system(size: 80))
                        .padding(.bottom, 8)
                    Button("使用 Face ID 解锁") { auth.unlock() }
                        .buttonStyle(.borderedProminent)
                    if auth.hasPassword {
                        VStack(spacing: 12) {
                            SecureField("Password", text: $password)
                                .textContentType(.password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button("Login") { auth.login(with: password) }
                                .buttonStyle(.borderedProminent)
                                .disabled(password.isEmpty)
                        }
                        .padding(.horizontal)
                    }
                    if let err = auth.authError {
                        Text(err.localizedDescription)
                            .foregroundColor(.red)
                    }
                    Spacer()
                }
                .padding()
            }
        }
        .animation(.easeInOut, value: auth.isUnlocked)
    }
}
