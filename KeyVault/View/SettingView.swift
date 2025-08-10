import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: LoginListViewModel
    @EnvironmentObject var auth: AuthViewModel

    @State private var showExporter = false
    @State private var showImporter = false
    @State private var document = LoginDocument()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button {
                        showImporter = true
                    } label: {
                        Label("Import", systemImage: "square.and.arrow.down")
                    }
                    Button {
                        if let data = vm.exportData() {
                            document = LoginDocument(data: data)
                            showExporter = true
                        }
                    } label: {
                        Label("Export", systemImage: "square.and.arrow.up")
                    }
                }
                Section {
                    NavigationLink {
                        PasswordSettingsView()
                            .environmentObject(auth)
                    } label: {
                        Label("Password", systemImage: "lock")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .fileExporter(isPresented: $showExporter,
                      document: document,
                      contentType: .json,
                      defaultFilename: "logins") { _ in }
        .fileImporter(isPresented: $showImporter,
                      allowedContentTypes: [.json]) { result in
            if let url = try? result.get() {
                guard url.startAccessingSecurityScopedResource() else { return }
                defer { url.stopAccessingSecurityScopedResource() }
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        vm.importData(data)
                    }
                }
            }
        }
    }
}
