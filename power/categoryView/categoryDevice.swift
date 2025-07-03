//
//  categoryDevice.swift
//  power
//
//  Created by 胡杰 on 2025/7/3.
//

import SwiftUI

struct CategoryDevice: View {
    let categoryType: String
    let categoryTag: CategoryItem
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
            ScrollView {
                if loadingStatus {
                    ProgressView()
                } else if let error = errorMessage {
                    Text("错误：\(error)")
                } else {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(devices) { item in
                            NavigationLink(destination: InformationView(inputDevice: item)) {
                                DeviceCard(device: item, isOwned: ownedDocumentIds.contains(item.documentId))
                            }
                        }
                    }
                    .padding()
                }
            }
            
            .navigationTitle(categoryTag.name)
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
        
        var requestParam: String = ""
        if categoryType == "brand" {
            requestParam = "filters[brand][$eqi]=" + categoryTag.name
        } else if categoryType == "type" {
            requestParam = "filters[type][$contains]=" + categoryTag.name
        } else if categoryType == "group" {
            switch categoryTag.name {
            case "充电宝":
                requestParam = "filters[group][$eq]=a1充电宝"
            case "充电器":
                requestParam = "filters[group][$eq]=a2充电头"
            default:
                requestParam = "filters[group][$eq]=a0其他"
            }
        }
        
        Task {
            do {
                let response: DeviceViewResponse = try await HTTPRequest.shared.get(endpoint: "/power-collectors?populate=*&" + requestParam, responseType: DeviceViewResponse.self)
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

#Preview {
    CategoryView()
}
