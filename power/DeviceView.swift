import SwiftUI



struct Device: Identifiable {
    let id = UUID()
    let name: String
    let height: CGFloat
}

let demoDevices: [Device] = (0..<20).map {
    Device(name: "电能块 \($0)", height: CGFloat.random(in: 150...250))
}

struct DeviceCardView: View {
    let device: Device

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 模拟图片区域（高度不等）
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .frame(height: device.height - 50)
                .overlay(
                    Text("图片")
                        .foregroundColor(.gray)
                )

            Text(device.name)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        )
    }
}

struct DeviceView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                WaterfallGrid(demoDevices) { device in
                    DeviceCardView(device: device)
                }
                .gridStyle(
                    columns: 2,
                    spacing: 12,
                    animation: .easeInOut(duration: 0.3)
                )
                .padding()
            }
            .navigationTitle("设备")
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

#Preview {
    DeviceView()
}
