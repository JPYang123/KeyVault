// AuthGateView.swift
import SwiftUI

struct AuthGateView: View {
    @StateObject private var auth = AuthViewModel()
    var body: some View {
        Group {
            if auth.isUnlocked {
                IndexedLoginListView()
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "faceid")
                        .font(.system(size: 60))
                    Button("使用 Face ID 解锁") { auth.unlock() }
                    if let err = auth.authError {
                        Text(err.localizedDescription).foregroundColor(.red)
                    }
                }
            }
        }
        .animation(.easeInOut, value: auth.isUnlocked)
    }
}
