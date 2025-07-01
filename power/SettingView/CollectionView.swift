//
//  CollectionView.swift
//  power
//
//  Created by HUAWEI MateBook X on 2025/6/28.
//

import SwiftUI

struct CollectionView: View {
    let items = [
        "A",
        "B",
        "C"
    ]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(items, id: \.self) { item in
                            HStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 60, height: 60)

                                VStack(alignment: .leading) {
                                    Text(item)
                                        .font(.headline)
                                    Text("点击查看详情")
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
            .navigationTitle("我的收藏")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CollectionView()
}
