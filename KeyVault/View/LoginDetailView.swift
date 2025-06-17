import SwiftUI

struct LoginDetailView: View {
    @ObservedObject var vm: LoginDetailViewModel
    @Environment(\.presentationMode) var presentation
    var parentVM: LoginListViewModel
    
    init(login: SecureLogin, parentVM: LoginListViewModel) {
        self.vm = LoginDetailViewModel(login: login)
        self.parentVM = parentVM
    }
    
    var body: some View {
        Form {
            Section(header: Text("帐号")) { Text(vm.login.userName) }
            Section(header: Text("密码")) {
                HStack {
                    Text(vm.password)
                    Spacer()
                    Button(vm.password == "••••••" ? "显示" : "隐藏") {
                        if vm.password == "••••••" {
                            vm.reveal()
                        } else {
                            vm.password = "••••••"
                        }
                    }
                }
            }
            if let note = vm.login.note {
                Section(header: Text("备注")) { Text(note) }
            }
        }
        .navigationTitle(Text(vm.login.title))
        .onAppear {
            if let updated = parentVM.logins.first(where: { $0.id == vm.login.id }) {
                vm.login = updated
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Label(vm.login.title, systemImage: vm.login.iconName)
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                NavigationLink("编辑") {
                    LoginEditView(parentVM: parentVM, editing: vm.login)
                }
                Button(role: .destructive) {
                    parentVM.delete(login: vm.login)
                    presentation.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
    }
}
