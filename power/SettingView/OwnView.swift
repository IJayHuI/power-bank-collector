//
//  OwnView.swift
//  power
//
//  Created by HUAWEI MateBook X on 2025/6/28.
//

import SwiftUI

struct OwnView: View {
    @State private var ownedItems = [
        "ANKER 65W 氮化镓充电器",
        "绿联 100W 双口快充头",
        "小米移动电源 20000mAh"
    ]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(ownedItems, id: \.self) { item in
                            HStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 60, height: 60)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item)
                                        .font(.headline)
                                    Text("已拥有")
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
            .navigationTitle("我的设备")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    OwnView()
}
