//
//  InformationView.swift
//  power
//
//  Created by 胡杰 on 2025/6/23.
//

import SwiftUI

struct InformationView: View {
    let device: Device
    
    var body: some View {
        VStack {
            Text("设备详情")
                .font(.largeTitle)
                .padding()
            Text("名称：\(device.name)")
                .font(.title2)
                .padding()
            // 可根据需要添加更多设备信息展示
        }
        .navigationTitle("详情")
    }
}
