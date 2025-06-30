//
//  AddItemSheetView.swift
//  power
//
//  Created by HUAWEI MateBook X on 2025/6/30.
//

import SwiftUI

struct AddItemSheetView1: View {
    let device: InformationViewDevice?
    let type: String
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                DatePicker("选择日期", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding()
                
                Spacer()
                
                Button(action: {
                    guard let device = device else { return }
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    let formattedDate = formatter.string(from: selectedDate)
                    
                    let status = (type == "拥有") ? 1 : 2
                    
                    do {
                        try LocalDatabase.shared.insertItem(
                            deviceId: device.id,
                            documentId: device.documentId,  // 这里传入 documentId
                            dateStr: formattedDate,
                            status: status,
                            powerDate: formattedDate,
                            imageUrl: device.thumbnail?.formats.small.url ?? "",
                            name: device.name
                        )
                        print("✅ 插入成功: \(device.name) | 状态: \(type) | 日期: \(formattedDate)")
                    } catch {
                        print("❌ 插入失败: \(error.localizedDescription)")
                    }
                    
                    dismiss()
                }) {
                    Text("添加")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
            }
            .padding()
            .navigationTitle("添加为「\(type)」")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
        }
    }
}
