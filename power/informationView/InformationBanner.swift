//
//  InformationBanner.swift
//  power
//
//  Created by 胡杰 on 2025/6/23.
//

import SwiftUI

struct InformationBanner: View {
    let inputDevice: InformationViewDevice?
    @Environment(\.colorScheme) var colorScheme
    @Binding var isOwned: Bool  // 默认 false，避免一开始就显示

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            bannerImage

            if isOwned {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(Color.green)
                        .font(.system(size: 18))
                    Text("已拥有")
                        .font(.caption)
//                        .foregroundColor(Color.accentColor)
                }
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.15), radius: 3, x: 1, y: 2)
                .padding(12)
                .transition(.opacity)
            }
        }
        .frame(height: 300)
        .onAppear {
            guard let docId = inputDevice?.documentId, !docId.isEmpty else {
                isOwned = false
                return
            }
            DispatchQueue.global(qos: .userInitiated).async {
                let owned = LocalDatabase.shared.isDeviceOwned(documentId: docId)
                print("你好",owned)
                DispatchQueue.main.async {
                    withAnimation {
                        isOwned = owned
                    }
                }
            }
        }
    }

    private var bannerImage: some View {
        Group {
            if let thumbnail = inputDevice?.thumbnail,
               let url = URL(string: "https://strapi.jayhu.site" + thumbnail.formats.small.url) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        placeholderImage
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        placeholderImage
                    @unknown default:
                        placeholderImage
                    }
                }
            } else {
                placeholderImage
            }
        }
        .frame(height: 300)
        .clipped()
        .cornerRadius(12)
    }

    private var placeholderImage: some View {
        ZStack {
            Color.gray.opacity(0.2)
            Image(systemName: "photo")
                .font(.system(size: 40))
                .foregroundColor(.blue)
        }
    }
}
