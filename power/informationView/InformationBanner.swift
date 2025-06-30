//
//   .swift
//  power
//
//  Created by 胡杰 on 2025/6/23.
//

import SwiftUI

struct InformationBanner: View {
    let inputDevice: InformationViewDevice?
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            if let thumbnail = inputDevice?.thumbnail,
               let url = URL(string: "https://strapi.jayhu.site" + thumbnail.formats.small.url) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300) // 设置图片高度
                            .clipped()
                            .cornerRadius(12)
                    case .failure:
                        VStack {
                            Image(systemName: "xmark")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)
                            Text("图片加载失败")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    @unknown default:
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                    }
                }
            } else {
                Image(systemName: "photo")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                    .frame(height: 300)
            }
        }
        .frame(height: 300) // 控制整体高度
    }
}

#Preview {
    DeviceView()
}
