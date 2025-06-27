//
//  DeviceView.swift
//  power
//
//  Created by 胡杰 on 2025/6/18.
//

import SwiftUI

// MARK: 设备主视图
struct DeviceView: View {
    @State private var devices: [DeviceViewDevice] = []
    @State private var loadingStatus = false
    @State private var errorMessage: String?
    @Namespace private var animationNamespace
    
    
    // 定义两列网格布局
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            if loadingStatus {
                ProgressView()
            } else if let error = errorMessage {
                Text("错误：\(error)")
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(devices) { item in
                            NavigationLink(destination: InformationView(inputDevice: item)) {
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
                let response: DeviceViewResponse = try await HTTPRequest.shared.get(endpoint: "/power-collectors?populate=*", responseType: DeviceViewResponse.self)
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
    let device: DeviceViewDevice
    var body: some View {
        VStack(spacing: 0) {
            if let firstImage = device.thumbnail,let url = URL(string: "https://strapi.jayhu.site" + (firstImage.formats.small.url)) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Image(systemName: "iphone")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .clipped()
                    case .failure(_):
                        Image(systemName: "xmark")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                    @unknown default:
                        Image(systemName: "iphone")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                    }
                }
            } else {
                Image(systemName: "iphone")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            }
            Text(device.name)
                .font(.headline)
                .lineLimit(2)
                .padding()
                .foregroundStyle(Color.primary)
        }
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.gray.opacity(0.4), lineWidth: 2)
        )
    }
}

// MARK: 设备相关模型
struct DeviceViewResponse: Codable {
    let data: [DeviceViewDevice]
}

struct DeviceViewDevice: Codable, Identifiable {
    let id: Int
    let documentId: String
    let name: String
    let thumbnail: DeviceViewThumbnail?
}

struct DeviceViewThumbnail: Codable {
    let id: Int
    let documentId: String
    let name: String
    let formats: DeviceViewFormats
}

struct DeviceViewFormats: Codable {
    let small: DeviceViewSmall
}

struct DeviceViewSmall: Codable {
    let url: String
}

#Preview {
    DeviceView()
}
