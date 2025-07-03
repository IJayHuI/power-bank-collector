//
//  searchResult.swift
//  power
//
//  Created by 胡杰 on 2025/7/3.
//

import SwiftUI

struct SearchResult: View {
    let keyword: String
    @State private var devices: [DeviceViewDevice] = []
    @State private var loadingStatus = false
    @State private var errorMessage: String?

    
    var body: some View {
        ScrollView {
            if loadingStatus {
                ProgressView()
            } else if let error = errorMessage {
                Text("错误：\(error)")
            } else {
                HStack {
                    Text(keyword)
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Text("iPhone 16支持Type-C接口与PD快充协议，选择充电宝时推荐20W以上、支持PD，APPLE，PPS的型号，兼顾快速、安全与兼容性。容量方面建议10000mAh以上，满足日常多次充电需求。轻薄便携的金属外壳款式更适合随身携带，是通勤、旅行的理想搭档。")
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.1))
                    )

                let chargerDevices = devices.filter { $0.group == "a2充电头" }
                let powerBankDevices = devices.filter { $0.group == "a1充电宝" }
                let otherDevices = devices.filter { $0.group == "a0其他" }

                VStack(alignment: .leading) {
                    Text("看看这些充电器")
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(chargerDevices) { device in
                                DeviceCard(device: device, isOwned: false)
                                    .frame(width: 180)
                            }
                        }
                        .padding(.horizontal)
                    }

                    Text("看看这些充电宝")
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(powerBankDevices) { device in
                                DeviceCard(device: device, isOwned: false)
                                    .frame(width: 180)
                            }
                        }
                        .padding(.horizontal)
                    }

                    Text("还有这些")
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(otherDevices) { device in
                                DeviceCard(device: device, isOwned: false)
                                    .frame(width: 180)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            Task {
                await getData()
            }
        }
    }

        private func getData() async {
        loadingStatus = true
        errorMessage = nil
        Task {
            do {
                let response: DeviceViewResponse = try await HTTPRequest.shared.get(endpoint: "/power-collectors?populate=*&filters[$or][0][type][$containsi]=pd&filters[$or][1][brand][$eqi]=apple", responseType: DeviceViewResponse.self)
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
