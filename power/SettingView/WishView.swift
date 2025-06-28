//
//  WishView.swift
//  power
//
//  Created by HUAWEI MateBook X on 2025/6/28.
//

import SwiftUI

struct WishView: View {
    @State private var wishItems = [
        "ANKER 240W 快充头",
        "绿联 2A2C 多口充电器",
        "MOMAX 轻薄充电宝"
    ]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(wishItems, id: \.self) { item in
                            HStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 60, height: 60)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item)
                                        .font(.headline)
                                    Text("未入手")
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
            .navigationTitle("愿望清单")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    WishView()
}
