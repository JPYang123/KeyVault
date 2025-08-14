// AuthGateView.swift
import SwiftUI

struct AuthGateView: View {
    @StateObject private var auth = AuthViewModel()
    @State private var password = ""
    @State private var showPassword = false

    var body: some View {
        Group {
            if auth.isUnlocked {
                IndexedLoginListView()
                    .environmentObject(auth)
            } else {
                GeometryReader { proxy in
                    let fieldWidth   = min(proxy.size.width * 0.78, 320) // narrower field
                    VStack(spacing: 32) {
                        Text("Sign in to KeyVault")
                            .font(.headline)
                            .padding(.top, 64)

                        if auth.hasPassword {
                            VStack(spacing: 32) {
                                HStack {
                                    Group {
                                        if showPassword {
                                            TextField("Password", text: $password)
                                        } else {
                                            SecureField("Password", text: $password)
                                        }
                                    }
                                    .textContentType(.password)

                                    Button(showPassword ? "Hide" : "Show") {
                                        showPassword.toggle()
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.accentColor)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .frame(width: fieldWidth) // <— constrain width
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.4))
                                )

                                Button("Sign in") {
                                    auth.login(with: password)
                                }
                                .frame(maxWidth: .infinity)
                                .buttonStyle(.borderedProminent)
                                .disabled(password.isEmpty)
                            }
                        }

                        if let err = auth.authError {
                            Text(err.localizedDescription)
                                .foregroundColor(.red)
                        }

                        if auth.hasPassword {
                            Button("Forgot your password?") {}
                                .font(.subheadline)
                                .tint(.accentColor)
                                .padding(.top, 8)
                        }

                        Spacer() // pushes Face ID area downward

                        Button(action: { auth.unlock() }) {
                            VStack {
                                Image(systemName: "faceid")
                                    .font(.system(size: 48))
                                Text("Sign in using Face ID")
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, proxy.size.height / 3) // <<< moves it up by 1/3 of screen
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
