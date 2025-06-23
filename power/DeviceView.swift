//
//  DeviceView.swift
//  power
//
//  Created by 胡杰 on 2025/6/18.
//

import SwiftUI

struct DeviceView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "iphone.gen3")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("设备")
                Text("HHHHHHHHH")
            }
            .navigationTitle("设备")
        }
    }
}

#Preview {
    DeviceView()
}
