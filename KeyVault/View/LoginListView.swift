// LoginListView.swift
import SwiftUI

struct LoginListView: View {
    @StateObject private var vm = LoginListViewModel()
    @State private var showAdd = false
    @State private var showSettings = false
    @EnvironmentObject var auth: AuthViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.filteredLogins) { item in
                    NavigationLink(destination: LoginDetailView(login: item, parentVM: vm)) {
                        HStack(spacing: 12) {
                            Image(systemName: item.iconName)
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(Color.accentColor)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            Text(item.title)
                                .font(.headline)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete(perform: vm.delete)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Logins")
            .navigationBarTitleDisplayMode(.inline)
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
                    .environmentObject(auth)
            }
            .sheet(isPresented: $showAdd) {
                LoginEditView(parentVM: vm)
            }
        }
    }
}
