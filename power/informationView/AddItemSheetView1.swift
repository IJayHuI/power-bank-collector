import SwiftUI

struct AddItemSheetView1: View {
    let device: InformationViewDevice?
    let type: String
    let showMaintenanceTime: Bool
    var onSuccess: (() -> Void)? = nil
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate = Date()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if showMaintenanceTime {
                    DatePicker("选择日期", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                }

                Spacer()
                
                Button(action: {
                    guard let device = device else { return }

                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    let formattedDate = formatter.string(from: selectedDate)

                    do {
                        let status: Int
                        switch type {
                        case "拥有": status = 1
                        case "愿望": status = 2
                        case "维护": status = 3
                        default: status = 0
                        }

                        try LocalDatabase.shared.insertItem(
                            deviceId: device.id,
                            documentId: device.documentId ?? "",
                            dateStr: formattedDate,
                            status: status,
                            powerDate: formattedDate,
                            imageUrl: device.thumbnail?.formats.small.url ?? "",
                            name: device.name
                        )

                        print("操作成功: \(type) - \(device.name) - 日期: \(formattedDate)")
                        LocalDatabase.shared.printAllItems()
                        onSuccess?() // 页面刷新
                    } catch {
                        print("数据库插入失败: \(error.localizedDescription)")
                    }

                    onSuccess?()  // 刷新
                    dismiss()
                }) {
                    Text("确认")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
            }
            .padding()
            .navigationTitle("添加为\(type)")
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
