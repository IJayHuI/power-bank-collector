//
//  SettingsView.swift
//  power
//
//  Created by 胡杰 on 2025/6/18.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "gear")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("设置页内容")
            }
            .navigationTitle("设置")
        }
    }
}

#Preview {
    SettingView()
}
