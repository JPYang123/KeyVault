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
                ZStack(alignment: .top) {
                    Circle()
                        .fill(Color.accentColor.opacity(0.2))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: "lock.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.accentColor)
                        )
                        .padding(.top, 60)

                    VStack(spacing: 32) {
                        Text("KeyVault")
                            .font(.largeTitle.bold())
                        Button {
                            auth.unlock()
                        } label: {
                            Label("使用 Face ID 解锁", systemImage: "faceid")
                        }
                        .buttonStyle(.borderedProminent)
                        if auth.hasPassword {
                            VStack(spacing: 12) {
                                SecureField("Password", text: $password)
                                    .textContentType(.password)
                                    .textFieldStyle(.roundedBorder)
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
                    .padding(.top, 216)
                    .padding(.horizontal)
                }
            }
        }
        .animation(.easeInOut, value: auth.isUnlocked)
    }
}

#if DEBUG
struct AuthGateView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AuthGateView()
                .previewDisplayName("Locked (Light)")
                .previewDevice("iPhone 15 Pro")

            AuthGateView()
                .previewDisplayName("Locked (Dark, XL Text)")
                .preferredColorScheme(.dark)
                .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
        }
    }
}
#endif
