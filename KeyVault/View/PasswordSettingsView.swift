import SwiftUI

struct PasswordSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var auth: AuthViewModel
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?

    var body: some View {
        Form {
            if auth.hasPassword {
                Section(header: Text("Change Password")) {
                    SecureField("Current Password", text: $currentPassword)
                    SecureField("New Password", text: $newPassword)
                    SecureField("Confirm Password", text: $confirmPassword)
                }
                if let errorMessage = errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                }
                Button("Change Password") {
                    guard newPassword == confirmPassword else {
                        errorMessage = "Passwords do not match"
                        return
                    }
                    if auth.changePassword(old: currentPassword, new: newPassword) {
                        dismiss()
                    } else {
                        errorMessage = "Current password is incorrect"
                    }
                }
            } else {
                Section(header: Text("Set Password")) {
                    SecureField("New Password", text: $newPassword)
                    SecureField("Confirm Password", text: $confirmPassword)
                }
                if let errorMessage = errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                }
                Button("Set Password") {
                    guard newPassword == confirmPassword else {
                        errorMessage = "Passwords do not match"
                        return
                    }
                    auth.setPassword(newPassword)
                    dismiss()
                }
            }
        }
        .navigationTitle("Password")
    }
}
