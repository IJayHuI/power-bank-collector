//
//  CollectionView.swift
//  power
//
//  Created by HUAWEI MateBook X on 2025/6/28.
//

import SwiftUI

struct CollectionView: View {
    let items = [
        "低碳生活，从绿色充电开始",
        "避免手机过夜充电的5个理由",
        "快充≠伤电池？全面解析充电误区",
        "国家电网推荐的充电安全指南",
        "支持UFCS的意义：推动统一快充标准"
    ]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(items, id: \.self) { item in
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.green.opacity(0.15))
                                    Image(systemName: "leaf.circle.fill") // 或"bolt.fill" "book.fill"等
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.green)
                                        .padding(12)
                                }
                                .frame(width: 60, height: 60)
                                VStack(alignment: .leading) {
                                    Text(item)
                                        .font(.headline)
                                    Text("查看文章内容")
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
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CollectionView()
}
