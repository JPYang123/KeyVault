import SwiftUI
import Foundation

struct LoginEditView: View {
    @Environment(\.presentationMode) var presentation
    @State private var title: String = ""
    @State private var user: String = ""
    @State private var pwd: String = ""
    @State private var note: String = ""
    
    var parentVM: LoginListViewModel
    var editing: SecureLogin?
    
    init(parentVM: LoginListViewModel, editing: SecureLogin? = nil) {
        self.parentVM = parentVM
        self.editing = editing
        _title = State(initialValue: editing?.title ?? "")
        _user  = State(initialValue: editing?.userName ?? "")
        _note  = State(initialValue: editing?.note ?? "")
        if let editing { // 预填充密码
            let pwdValue = (try? KeychainService.shared.readPassword(for: editing.keychainKey)) ?? ""
            _pwd = State(initialValue: pwdValue)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("标题", text: $title)
                TextField("用户名", text: $user)
                TextField("密码", text: $pwd)
                    .textContentType(.password)
                TextEditor(text: $note)
                    .frame(minHeight: 80)
            }
            .navigationTitle(editing == nil ? "新建条目" : "编辑条目")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") { presentation.wrappedValue.dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        let key = editing?.keychainKey ?? UUID().uuidString
                        let login = SecureLogin(id: editing?.id ?? UUID(),
                                                title: title,
                                                userName: user,
                                                keychainKey: key,
                                                note: note.isEmpty ? nil : note)
                        if let _ = editing {
                            parentVM.update(login: login, password: pwd.isEmpty ? nil : pwd)
                        } else {
                            parentVM.add(login: login, password: pwd)
                        }
                        presentation.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty || user.isEmpty)
                }
            }
        }
    }
}
