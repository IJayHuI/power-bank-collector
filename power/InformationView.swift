//
//  InformationView.swift
//  power
//
//  Created by 胡杰 on 2025/6/23.
//

import SwiftUI

struct AddSheetType: Identifiable, Equatable {
    let id = UUID()
    let value: String
}

struct InformationView: View {
    let inputDevice: DeviceViewDevice
    @State private var device: InformationViewDevice? = nil
    @State private var loadingStatus = false
    @State private var errorMessage: String? = nil
    @State private var addSheetType: AddSheetType? = nil
    @State private var isOwned = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if let device = device {
                        InformationBanner(inputDevice: device, isOwned: $isOwned) // ✅ 传入绑定
                        InfomationContent(inputDevice: device)
                    }
                }
                .padding(.top, 16)
            }
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            addSheetType = AddSheetType(value: "拥有")
                        } label: {
                            Label("拥有", systemImage: "plus")
                        }

                        Button {
                            addSheetType = AddSheetType(value: "愿望")
                        } label: {
                            Label("愿望", systemImage: "plus")
                        }

                        if isOwned {
                            Button {
                                addSheetType = AddSheetType(value: "维护")
                            } label: {
                                Label("维护", systemImage: "wrench.adjustable")
                            }
                        }

                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .medium))
                            .padding(8)
                    }
                }
            }
            .sheet(item: $addSheetType) { sheetType in
                AddItemSheetView1(
                    device: device,
                    type: sheetType.value,
                    showMaintenanceTime: sheetType.value == "拥有" || sheetType.value == "维护",
                    onSuccess: {
                        checkIsOwned() // ✅ 点确认后刷新 isOwned
                    }
                )
            }
            .navigationTitle(device?.name ?? "设备详情")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task { await getData() }
            }
        }
    }
    
    private func getData() async {
        loadingStatus = true
        errorMessage = nil
        Task {
            do {
                let data = try await HTTPRequest.shared.getRawData(endpoint: "/power-collectors/\(inputDevice.documentId)?populate=*")
                if let jsonStr = String(data: data, encoding: .utf8) {
                    print("JSON:\n\(jsonStr)")
                }

                let response = try JSONDecoder().decode(InformationViewResponse.self, from: data)
                await MainActor.run {
                    self.device = response.data
                    self.loadingStatus = false
                    self.checkIsOwned()
                }
            } catch {
                print("请求失败：", error.localizedDescription)
                loadingStatus = false
            }
        }
    }

    private func checkIsOwned() {
        Task {
            do {
                let ownedItems = try LocalDatabase.shared.fetchOwnedItems()
                if let currentDocId = device?.documentId {
                    let isMatch = ownedItems.contains { $0.documentId == currentDocId }
                    await MainActor.run {
                        isOwned = isMatch
                    }
                }
            } catch {
                print("本地查询失败: \(error.localizedDescription)")
                await MainActor.run {
                    isOwned = false
                }
            }
        }
    }
}

struct InformationViewResponse: Codable {
    let data: InformationViewDevice
}

struct InformationViewDevice: Codable, Identifiable {
    let id: Int
    let documentId: String?
    let name: String
    let createdAt: String
    let updatedAt: String
    let publishedAt: String
    let model: String
    let brand: String
    let type: [String]
    let size: String
    let weight: Double
    let input: [String]
    let output: [String]
    let wireless: [String]
    let capacity: String
    let group: String
    let image: [InformationViewImage]?
    let thumbnail: DeviceViewThumbnail?

    enum CodingKeys: String, CodingKey {
        case id, documentId, name, createdAt, updatedAt, publishedAt
        case model, brand, type, size, weight, input, output, wireless, capacity, group, image, thumbnail
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        documentId = try container.decodeIfPresent(String.self, forKey: .documentId)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? "暂无"
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? "暂无"
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? "暂无"
        publishedAt = try container.decodeIfPresent(String.self, forKey: .publishedAt) ?? ""

        model = try container.decodeIfPresent(String.self, forKey: .model) ?? "暂无"
        brand = try container.decodeIfPresent(String.self, forKey: .brand) ?? "暂无"
        type = try container.decodeIfPresent([String].self, forKey: .type) ?? []
        size = try container.decodeIfPresent(String.self, forKey: .size) ?? "暂无"
        weight = try container.decodeIfPresent(Double.self, forKey: .weight) ?? 0.0
        input = try container.decodeIfPresent([String].self, forKey: .input) ?? []
        output = try container.decodeIfPresent([String].self, forKey: .output) ?? []
        wireless = try container.decodeIfPresent([String].self, forKey: .wireless) ?? []
        capacity = try container.decodeIfPresent(String.self, forKey: .capacity) ?? "暂无"
        group = try container.decodeIfPresent(String.self, forKey: .group) ?? "暂无"

        image = try container.decodeIfPresent([InformationViewImage].self, forKey: .image)
        thumbnail = try container.decodeIfPresent(DeviceViewThumbnail.self, forKey: .thumbnail)
    }
}

struct InformationViewImage: Codable, Identifiable {
    let id: Int
    let documentId: String
    let name: String
    let width: Int
    let height: Int
    let url: String
}

#Preview {
    DeviceView()
}
