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
    @State private var ownedDocumentIds: Set<String> = []
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
                                    DeviceCard(device: item, isOwned: ownedDocumentIds.contains(item.documentId))
                                }
                            }
                        }
                        .padding()
                        .navigationTitle("设备")
                    }
                }
            }
            .onAppear {
                Task {
                    await getData()
                    fetchOwnedIds()
                }
            }
            .refreshable {
                await getData()
                fetchOwnedIds()
            }
        }

        private func fetchOwnedIds() {
            do {
                let ownedItems = try LocalDatabase.shared.fetchOwnedItems()
                let ownedIds = Set(ownedItems.map { $0.documentId })
                ownedDocumentIds = ownedIds
            } catch {
                print("获取已拥有设备失败：\(error.localizedDescription)")
                ownedDocumentIds = []
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
    let isOwned: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) { 
            VStack(spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.05))

                    if let firstImage = device.thumbnail,
                       let url = URL(string: "https://strapi.jayhu.site" + firstImage.formats.small.url) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                placeholderImage
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .clipped()
                            case .failure(_):
                                errorImage
                            @unknown default:
                                placeholderImage
                            }
                        }
                    } else {
                        placeholderImage
                    }
                }
                .frame(height: 140)
                .clipped()
                .cornerRadius(20)

                Text(device.name)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .padding([.top, .horizontal], 8)
                    .padding(.bottom, 12)
            }
            .background(Color.white)
            .cornerRadius(25)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            
            if isOwned {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(Color.green)
                    }
                    .padding(6)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 1, y: 1)
                    .padding(8)
                    .transition(.opacity)
                }
        }
    }

    private var placeholderImage: some View {
        Image(systemName: "iphone")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
            .foregroundColor(.blue.opacity(0.6))
    }

    private var errorImage: some View {
        VStack {
            Image(systemName: "xmark.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.red)
            Text("加载失败")
                .font(.caption)
                .foregroundColor(.gray)
        }
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
