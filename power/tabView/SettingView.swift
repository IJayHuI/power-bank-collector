//
//  SettingsView.swift
//  power
//
//  Created by 胡杰 on 2025/6/18.
//

import SwiftUI

import SwiftUI

struct SettingView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                HStack {
                    Text("设置")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                .padding(.horizontal)

                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 150)
                    .padding(.horizontal)

                // 按钮列表
                VStack(spacing: 12) {
                    ForEach(["维护", "拥有", "收藏", "愿望"], id: \.self) { title in
                        Button(action: {
                            // 点击事件
                        }) {
                            HStack {
                                    Text(title)
                                        .font(.headline)
                                            Spacer()
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(20)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)

                Spacer()

            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    SettingView()
}

#Preview {
    SettingView()
}
