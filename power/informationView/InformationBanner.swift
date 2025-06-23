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
        VStack{
            if let device = inputDevice, let images = device.image, !images.isEmpty {
                TabView {
                    ForEach(images) { img in
                        if let url = URL(string: "https://strapi.jayhu.site" + img.url) {
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
                                        .clipped()
                                case .failure:
                                    Image(systemName: "xmark")
                                        .font(.system(size: 40))
                                        .foregroundColor(.blue)
                                    Text("图片加载失败")
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
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .onAppear {
                    if colorScheme == .light {
                        UIPageControl.appearance().currentPageIndicatorTintColor = .black // 当前页指示器为黑色
                        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.3) // 其他页指示器半透明黑色
                    }
                }
            } else {
                // 加载中或无图片时显示
                Image(systemName: "photo")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
            }
        }
        .frame(height: 500)
    }
}

#Preview {
    DeviceView()
}
