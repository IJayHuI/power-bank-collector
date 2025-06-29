//
//  InformationView.swift
//  power
//
//  Created by 胡杰 on 2025/6/23.
//

import SwiftUI

struct InformationView: View {
    let inputDevice: DeviceViewDevice
    @State private var device: InformationViewDevice? = nil
    @State private var loadingStatus = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        ScrollView {
            InformationBanner(inputDevice: device)
            InfomationContent(inputDevice: device)
        }
        .ignoresSafeArea()
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            Task { await getData() }
        }
    }
    
    private func getData() async {
        loadingStatus = true
        errorMessage = nil
        Task {
            do {
                let response: InformationViewResponse = try await HTTPRequest.shared.get(endpoint: "/power-collectors/\(inputDevice.documentId)?populate=*", responseType: InformationViewResponse.self)
                print("详情页请求数据", response.data)
                await MainActor.run {
                    self.device = response.data
                }
                self.loadingStatus = false
            } catch {
                print("请求失败：", error.localizedDescription)
                self.loadingStatus = false
            }
        }
    }
    
}

struct InformationViewResponse: Codable {
    let data: InformationViewDevice
}

struct InformationViewDevice: Codable, Identifiable {
    let id: Int
    let documentId: String
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
    
    // 设置默认值
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            id = try container.decode(Int.self, forKey: .id)
            documentId = try container.decodeIfPresent(String.self, forKey: .documentId) ?? ""
            name = try container.decodeIfPresent(String.self, forKey: .name) ?? "暂无"
            createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? "暂无"
            updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? "暂无"
            publishedAt = try container.decodeIfPresent(String.self, forKey: .publishedAt) ?? ""
            model = try container.decodeIfPresent(String.self, forKey: .model) ?? "暂无"
            brand = try container.decodeIfPresent(String.self, forKey: .brand) ?? "暂无"
            type = try container.decodeIfPresent([String].self, forKey: .type) ?? []
            size = try container.decodeIfPresent(String.self, forKey: .size) ?? "暂无"
            weight = try container.decodeIfPresent(Double.self, forKey: .weight) ?? 0
            input = try container.decodeIfPresent([String].self, forKey: .input) ?? []
            output = try container.decodeIfPresent([String].self, forKey: .output) ?? []
            wireless = try container.decodeIfPresent([String].self, forKey: .wireless) ?? []
            capacity = try container.decodeIfPresent(String.self, forKey: .capacity) ?? "暂无"
            group = try container.decodeIfPresent(String.self, forKey: .group) ?? "暂无"
            image = try container.decodeIfPresent([InformationViewImage].self, forKey: .image)
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
