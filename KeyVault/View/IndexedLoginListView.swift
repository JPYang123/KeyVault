import SwiftUI

struct IndexedLoginListView: View {
    @StateObject private var vm = LoginListViewModel()
    @State private var showSettings = false
    
    // 拆分后更易通过编译
    private var grouped: [(key: String, value: [SecureLogin])] {
        let dict = Dictionary(grouping: vm.logins, by: { login in
            login.title.first?.uppercased() ?? "#"
        })
        let mapped = dict.mapValues { group in
            group.sorted { $0.title < $1.title }
        }
        let sortedArr = mapped.sorted { lhs, rhs in
            lhs.key < rhs.key
        }
        return sortedArr
    }

    private var indexTitles: [String] {
        grouped.map { $0.key }
    }

    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in

                // 1️⃣ 先声明 indexBar
                let indexBar = SectionIndexBar(titles: indexTitles) { letter in
                    withAnimation {
                        proxy.scrollTo(letter, anchor: .top)
                    }
                }
                .frame(width: 20)
                .frame(maxHeight: .infinity)
                .contentShape(Rectangle())
                .padding(.trailing, 2)    // ← 这里原来漏了右括号

                // 2️⃣ 列表主体
                List {
                    ForEach(grouped, id: \.key) { section in
                        Section(header:
                            Text(section.key)
                                .font(.headline)
                                .id(section.key)      // 确保 header 上有 id
                        ) {
                            ForEach(section.value) { login in
                                NavigationLink(
                                    destination: LoginDetailView(login: login, parentVM: vm)
                                ) {
                                    Label(login.title, systemImage: "globe")
                                }
                            }
                        }
                    }
                }
                // 3️⃣ 在 List 上叠加 indexBar
                .overlay(indexBar, alignment: .trailing)
                .navigationTitle("Logins")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                         Button {
                             showSettings = true
                         } label: {
                             Image(systemName: "gearshape")
                         }
                     }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            LoginEditView(parentVM: vm)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showSettings) {
                    SettingsView(vm: vm)
                }
            }
        }
    }
}
