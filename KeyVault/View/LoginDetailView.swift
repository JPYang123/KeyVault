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
                    Button("显示") { vm.reveal() }
                }
            }
            if let note = vm.login.note {
                Section(header: Text("备注")) { Text(note) }
            }
        }
        .navigationTitle(vm.login.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("编辑") {
                    LoginEditView(parentVM: parentVM, editing: vm.login)
                }
            }
        }
    }
}
