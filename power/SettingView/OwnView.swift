//
//  OwnView.swift
//  power
//
//  Created by HUAWEI MateBook X on 2025/6/28.
//

import SwiftUI

struct OwnView: View {
    @State private var ownedItems: [OwnedItem] = []
    @State private var isLoading = false
    @State private var errorMessage: String? = nil

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("加载中...")
                } else if let error = errorMessage {
                    Text("错误：\(error)")
                        .foregroundColor(.red)
                } else if ownedItems.isEmpty {
                    Text("暂无已拥有设备")
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(ownedItems) { item in
                                NavigationLink(destination: InformationView(inputDevice: DeviceViewDevice(
                                    id: item.itemid,
                                    documentId: "", // 本地没有 documentId，传空字符串
                                    name: item.name,
                                    thumbnail: DeviceViewThumbnail(
                                        id: 0,
                                        documentId: "",
                                        name: "",
                                        formats: DeviceViewFormats(
                                            small: DeviceViewSmall(url: item.image)
                                        )
                                    )
                                ))) {
                                    HStack {
                                        if let url = URL(string: "https://strapi.jayhu.site" + item.image) {
                                            AsyncImage(url: url) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                case .success(let image):
                                                    image.resizable()
                                                        .scaledToFill()
                                                case .failure(_):
                                                    Image(systemName: "photo")
                                                        .resizable()
                                                        .scaledToFit()
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(8)
                                        } else {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(width: 60, height: 60)
                                        }

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(item.name)
                                                .font(.headline)
                                            Text("已拥有 - 添加日期: \(item.date)")
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
                    }
                }
            }
            .navigationTitle("我的设备")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadData()
            }
        }
    }

    func loadData() {
        isLoading = true
        errorMessage = nil

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let items = try LocalDatabase.shared.fetchOwnedItems()
                DispatchQueue.main.async {
                    self.ownedItems = items
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}

#Preview {
    OwnView()
}
