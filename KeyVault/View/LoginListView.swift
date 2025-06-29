// LoginListView.swift
import SwiftUI

struct LoginListView: View {
    @StateObject private var vm = LoginListViewModel()
    @State private var showAdd = false
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.filteredLogins) { item in
                    NavigationLink(destination: LoginDetailView(login: item, parentVM: vm)) {
                        Label(item.title, systemImage: item.iconName)
                    }
                }
                .onDelete(perform: vm.delete)
            }
            .navigationTitle("Logins")
            .searchable(text: $vm.searchText)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAdd = true }) { Image(systemName: "plus") }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(vm: vm)
            }
            .sheet(isPresented: $showAdd) {
                LoginEditView(parentVM: vm)
            }
        }
    }
}
