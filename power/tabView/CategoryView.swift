//
//  CategoryView.swift
//  power
//
//  Created by 胡杰 on 2025/6/18.
//

import SwiftUI

let categoryData: [CategoryItem] = [
    CategoryItem(name: "品牌", children:
                    [CategoryItem(name: "Anker", children: nil, parentName: "brand"),
                     CategoryItem(name: "Apple", children: nil, parentName: "brand"),
                     CategoryItem(name: "Belkin", children: nil, parentName: "brand"),
                     CategoryItem(name: "CUKTECH", children: nil, parentName: "brand"),
                     CategoryItem(name: "倍思", children: nil, parentName: "brand"),
                     CategoryItem(name: "制糖工厂", children: nil, parentName: "brand"),
                     CategoryItem(name: "小米", children: nil, parentName: "brand"),
                     CategoryItem(name: "绿联", children: nil, parentName: "brand"),
                     CategoryItem(name: "罗马仕", children: nil, parentName: "brand"),
                     CategoryItem(name: "闪极", children: nil, parentName: "brand")
                    ]),
    CategoryItem(name: "协议", children:
                    [CategoryItem(name: "Apple", children: nil, parentName: "type"),
                     CategoryItem(name: "FCP", children: nil, parentName: "type"),
                     CategoryItem(name: "Mipps", children: nil, parentName: "type"),
                     CategoryItem(name: "PD", children: nil, parentName: "type"),
                     CategoryItem(name: "PPS", children: nil, parentName: "type"),
                     CategoryItem(name: "QC", children: nil, parentName: "type"),
                     CategoryItem(name: "SCP", children: nil, parentName: "type"),
                     CategoryItem(name: "UFCS", children: nil, parentName: "type")
                    ]),
    CategoryItem(name: "功率", children:
                    [CategoryItem(name: "10W", children: nil, parentName: "type"),
                     CategoryItem(name: "15W", children: nil, parentName: "type"),
                     CategoryItem(name: "20W", children: nil, parentName: "type"),
                     CategoryItem(name: "30W", children: nil, parentName: "type"),
                     CategoryItem(name: "35W", children: nil, parentName: "type"),
                     CategoryItem(name: "45W", children: nil, parentName: "type"),
                     CategoryItem(name: "65W", children: nil, parentName: "type"),
                     CategoryItem(name: "67W", children: nil, parentName: "type"),
                     CategoryItem(name: "70W", children: nil, parentName: "type"),
                     CategoryItem(name: "100W", children: nil, parentName: "type"),
                     CategoryItem(name: "120W", children: nil, parentName: "type"),
                     CategoryItem(name: "140W", children: nil, parentName: "type"),
                     CategoryItem(name: "200W", children: nil, parentName: "type")
                    ]),
    CategoryItem(name: "类型", children:
                    [CategoryItem(name: "充电器", children: nil, parentName: "group"),
                     CategoryItem(name: "充电宝", children: nil, parentName: "group"),
                     CategoryItem(name: "其他", children: nil, parentName: "group")
                    ])
]


struct CategoryItem: Hashable, Identifiable, CustomStringConvertible {
    var id: Self { self }
    var name: String
    var children: [CategoryItem]? = nil
    var description: String {
        switch children {
        case nil:
            return "\(name)"
        case .some(_):
            return "\(name)"
        }
    }
    var parentName: String? = nil
}

struct CategoryView: View {
    var body: some View {
        NavigationStack {
            List(categoryData, children: \.children) { item in
                if item.children == nil {
                    // 子项，点击跳转
                    NavigationLink(destination: CategoryDevice(categoryType: item.parentName ?? "", categoryTag: item)) {
                        Text(item.description)
                    }
                } else {
                    // 分类项，仅显示文本
                    Text(item.description)
                        .font(.headline)
                }
            }
            
            .navigationTitle("分类")
        }
    }
}


#Preview {
    CategoryView()
}
