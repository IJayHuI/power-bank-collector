//
//  SearchView.swift
//  power
//
//  Created by 胡杰 on 2025/6/18.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "magnifyingglass")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("搜索")
            }
            .navigationTitle("搜索")
        }
    }
}

#Preview{
    SearchView()
}
