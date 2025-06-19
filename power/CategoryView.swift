//
//  CategoryView.swift
//  power
//
//  Created by 胡杰 on 2025/6/18.
//

import SwiftUI

struct CategoryView: View {
    @State private var brandExpanded = true
    @State private var powerExpanded = false
    
    let brands = [
        (name: "Apple", icon: "applelogo"),
        (name: "华为", icon: "h.circle"),
        (name: "小米", icon: "m.circle"),
        (name: "OPPO", icon: "o.circle"),
        (name: "VIVO", icon: "v.circle")
    ]
    let powers = [
        (name: "100W+", icon: "bolt.fill"),
        (name: "60-100W", icon: "bolt"),
        (name: "30-60W", icon: "bolt.slash"),
        (name: "30W以下", icon: "bolt.circle")
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment:.leading, spacing: 14) {
                    // 品牌分组
                    Section {
                        Text("品牌")
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                            .padding(.leading)
                        
                        
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack(spacing: 18) {
                                ForEach(brands, id: \.name) { item in
                                    CategoryCard(icon: item.icon, name: item.name, color: Color.primary)
                                        .frame(width: 100)
                                }
                            }
                            .padding(.leading)
                        }
                    }
                    // 功率分组
                    Section {
                        Text("功率")
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                            .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack(spacing: 18) {
                                ForEach(powers, id: \.name) { item in
                                    CategoryCard(icon: item.icon, name: item.name, color: Color.primary)
                                        .frame(width: 100)
                                }
                            }
                            .padding(.leading)
                        }
                    }
                }
            }
            .navigationTitle("分类")
        }
    }
}

struct CategoryCard: View {
    let icon: String
    let name: String
    let color: Color
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundColor(color)
            Text(name)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    CategoryView()
}
