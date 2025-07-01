//
//  MaintenanceView.swift
//  power
//
//  Created by HUAWEI MateBook X on 2025/6/28.
//

import SwiftUI

struct MaintenanceView: View {
    @State private var maintenanceItems: [MaintenanceItem] = []
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
                } else if maintenanceItems.isEmpty {
                    Text("暂无需维护设备")
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(maintenanceItems) { item in
                                MaintenanceItemRow(item: item)
                            }
                        }
                        .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("设备维护")
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
                let items = try LocalDatabase.shared.fetchMaintenanceItems()
                DispatchQueue.main.async {
                    self.maintenanceItems = items
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

struct MaintenanceItemRow: View {
    let item: MaintenanceItem

    var body: some View {
        NavigationLink(destination: InformationView(inputDevice: DeviceViewDevice(
            id: Int(item.itemid),
            documentId: item.documentId,
            name: item.name,
            thumbnail: nil
        ))) {
            HStack {
                deviceImage
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                    Text("需维护 - 添加日期: \(item.date)")
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

    private var deviceImage: some View {
        if let url = URL(string: "https://strapi.jayhu.site" + item.image) {
            return AnyView(
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable().scaledToFit()
                    @unknown default:
                        EmptyView()
                    }
                }
            )
        } else {
            return AnyView(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
            )
        }
    }
}
