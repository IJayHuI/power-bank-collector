//
//  SearchView.swift
//  power
//
//  Created by 胡杰 on 2025/6/18.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var isSearching = false
    
    var body: some View {
        TabView {
            Tab("设备", systemImage: "iphone.gen3") {
                DeviceView()
            }
            Tab("分类", systemImage: "square.grid.2x2.fill") {
                CategoryView()
            }
            Tab("设置", systemImage: "gear") {
                SettingView()
            }
            Tab("搜索", systemImage: "magnifyingglass", role: .search) {
                NavigationStack {
                    VStack {
                        SearchView()
                    }
                        .searchable(text: $searchText, prompt: "搜索")
                        .onSubmit(of: .search) {
                            isSearching = true
                        }
                        .navigationDestination(isPresented: $isSearching) {
                            SearchResult(keyword: searchText)
                        }
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    ContentView()
}
