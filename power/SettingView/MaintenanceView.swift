//
//  MaintenanceView.swift
//  power
//
//  Created by HUAWEI MateBook X on 2025/6/28.
//

import SwiftUI

struct MaintenanceView: View {
    @State private var maintenanceItems = [
        "ANKER 45W 充电头（Type-C接口松动）",
        "罗马仕 移动电源（需要更换电池）",
        "绿联 USB-C线（线皮破损）"
    ]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(maintenanceItems, id: \.self) { item in
                            HStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 60, height: 60)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item)
                                        .font(.headline)
                                    Text("待维护")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                }

                Spacer()
            }
            .navigationTitle("设备维护")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MaintenanceView()
}
