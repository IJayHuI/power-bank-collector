import SwiftUI

struct SettingView: View {
    @State private var ownCount: Int = 0
    @State private var wishCount: Int = 0
    @State private var maintenanceCount: Int = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 标题
                HStack {
                    Text("设置")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 45)

                // 顶部数据统计卡片
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 130)
                    .overlay(
                        VStack(alignment: .leading, spacing: 12) {
                            Text("概览")
                                .font(.headline)

                            HStack(spacing: 20) {
                                statBox(icon: "checkmark.seal.fill", title: "已拥有", count: ownCount, color: .green)
                                statBox(icon: "star.fill", title: "愿望", count: wishCount, color: .orange)
                                statBox(icon: "wrench.and.screwdriver.fill", title: "需维护", count: maintenanceCount, color: .red)
                            }
                        }
                        .padding()
                    )
                    .padding(.horizontal)

                // 四个跳转按钮
                VStack(spacing: 10) {
                    NavigationLink(destination: MaintenanceView()) {
                        settingButton(title: "维护", icon: "wrench.and.screwdriver")
                    }
                    NavigationLink(destination: OwnView()) {
                        settingButton(title: "拥有", icon: "checkmark.seal")
                    }
                    NavigationLink(destination: CollectionView()) {
                        settingButton(title: "收藏", icon: "heart")
                    }
                    NavigationLink(destination: WishView()) {
                        settingButton(title: "愿望", icon: "star")
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onAppear {
                loadCounts()
            }
        }
        
    }

    // 统计数据加载
    func loadCounts() {
        ownCount = LocalDatabase.shared.countItems(withStatus: 1)
        wishCount = LocalDatabase.shared.countItems(withStatus: 2)
        maintenanceCount = LocalDatabase.shared.countDueMaintenanceItems() // 同已拥有
    }

    func settingButton(title: String, icon: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(.primary)
                .font(.system(size: 20))
                

            Text(title)
                .foregroundColor(.primary)
                .font(.system(size: 17, weight: .medium))

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        )
    }
}

// 单个统计框
func statBox(icon: String, title: String, count: Int, color: Color) -> some View {
    VStack(spacing: 8) {
        Image(systemName: icon)
            .font(.system(size: 20))
            .foregroundColor(color)

        Text("\(count)")
            .font(.title2)
            .bold()

        Text(title)
            .font(.caption)
            .foregroundColor(.gray)
    }
    .frame(maxWidth: .infinity)
}

#Preview {
    SettingView()
}
