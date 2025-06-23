//
//  DeviceView.swift
//  power
//
//  Created by 胡杰 on 2025/6/18.
//

import SwiftUI

// MARK: 设备主视图
struct DeviceView: View {
    @State private var devices: [Device] = []
    @State private var loadingStatus = false
    @State private var errorMessage: String?
    
    // 定义两列网格布局
    private let columns = [
        GridItem(.flexible(),spacing: 18),
        GridItem(.flexible(),spacing: 18)
    ]
    
    var body: some View {
        NavigationStack {
            if loadingStatus {
                ProgressView()
            } else if let error = errorMessage {
                Text("错误：\(error)")
            } else {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(devices) { item in
                            NavigationLink(destination: InformationView(device: item)) {
                                DeviceCard(device: item)
                            }
                        }
                    }
                    .padding()
                    .navigationTitle("设备")
                }
            }
        }
        .onAppear {
            Task { await getData() }
        }
        .refreshable {
            await getData()
        }
    }
    
    private func getData() async {
        loadingStatus = true
        errorMessage = nil
        Task {
            do {
                let response: DataListResponse = try await HTTPRequest.shared.get(endpoint: "/power-collectors?populate=*", responseType: DataListResponse.self)
                await MainActor.run {
                    self.devices = response.data
                }
                print("结果",response.data)
                self.loadingStatus = false
            } catch {
                print("请求失败：", error.localizedDescription)
                self.loadingStatus = false
            }
        }
    }
}

//MARK: 设备卡片组件
struct DeviceCard: View {
    let device: Device
    var body: some View {
        VStack {
            if let firstImage = device.image?.first,let url = URL(string: "https://strapi.jayhu.site" + (firstImage.formats.medium.url)) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .scaledToFit()
                    } else if phase.error != nil {
                        Image(systemName: "iphone")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                        
                    } else {
                        ProgressView()
                    }
                }
                .frame(height: 120)
                .frame(maxWidth: .infinity)
            } else {
                Image(systemName: "iphone")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
            }
            Text(device.name)
                .font(.headline)
                .lineLimit(2)
                .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(25)
        .shadow(radius: 1)
    }
}

// MARK: 设备相关模型
struct DataListResponse: Codable {
    let data: [Device]
}

struct Device: Codable, Identifiable {
    let id: Int
    let documentId: String
    let name: String
    let image: [DeviceImage]?
}

struct DeviceImage: Codable {
    let id: Int
    let documentId: String
    let name: String
    let formats: Formats
}

struct Formats: Codable {
    let medium: Medium
}

struct Medium: Codable {
    let url: String
}

#Preview {
    DeviceView()
}
