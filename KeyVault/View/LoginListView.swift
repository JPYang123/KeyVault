// LoginListView.swift
import SwiftUI

struct LoginListView: View {
    @StateObject private var vm = LoginListViewModel()
    @State private var showAdd = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.logins) { item in
                    NavigationLink(destination: LoginDetailView(login: item, parentVM: vm)) {
                        Label(item.title, systemImage: "globe")
                    }
                }
                .onDelete(perform: vm.delete)
            }
            .navigationTitle("Logins")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAdd = true }) { Image(systemName: "plus") }
                }
            }
            .sheet(isPresented: $showAdd) {
                LoginEditView(parentVM: vm)
            }
        }
    }
}
