//
//  CategoryView.swift
//  power
//
//  Created by 胡杰 on 2025/6/18.
//

import SwiftUI

//let categoryData: [FileItem] = [
//    FileItem(name: "users", children:
//                [FileItem(name: "user1234", children:
//                            [FileItem(name: "Photos", children:
//                                        [FileItem(name: "photo001.jpg"),
//                                         FileItem(name: "photo002.jpg")]),
//                             FileItem(name: "Movies", children:
//                                        [FileItem(name: "movie001.mp4")]),
//                             FileItem(name: "Documents", children: [])
//                            ]),
//                 FileItem(name: "newuser", children:
//                            [FileItem(name: "Documents", children: [])
//                            ])
//                ]),
//    FileItem(name: "private", children: nil)
//]

let categoryData: [FileItem] = [
    FileItem(name: "品牌", children:
                [FileItem(name: "Anker", children: nil),
                 FileItem(name: "Apple", children: nil),
                 FileItem(name: "Belkin", children: nil),
                 FileItem(name: "CUKTECH", children: nil),
                 FileItem(name: "倍思", children: nil),
                 FileItem(name: "制糖工厂", children: nil),
                 FileItem(name: "小米", children: nil),
                 FileItem(name: "绿联", children: nil),
                 FileItem(name: "罗马仕", children: nil),
                 FileItem(name: "闪极", children: nil)
                ]),
    FileItem(name: "协议", children:
                [FileItem(name: "Apple", children: nil),
                 FileItem(name: "FCP", children: nil),
                 FileItem(name: "Mipps", children: nil),
                 FileItem(name: "PD", children: nil),
                 FileItem(name: "PPS", children: nil),
                 FileItem(name: "QC", children: nil),
                 FileItem(name: "SCP", children: nil),
                 FileItem(name: "UFCS", children: nil)
                ]),
    FileItem(name: "功率", children:
                [FileItem(name: "5W以上", children: nil),
                 FileItem(name: "10W以上", children: nil),
                 FileItem(name: "20W以上", children: nil),
                 FileItem(name: "30W以上", children: nil),
                 FileItem(name: "40W以上", children: nil),
                 FileItem(name: "60W以上", children: nil),
                 FileItem(name: "100W以上", children: nil)
                ]),
    FileItem(name: "类型", children:
                [FileItem(name: "充电器", children: nil),
                 FileItem(name: "充电宝", children: nil),
                 FileItem(name: "其他", children: nil)
                ])
]


struct FileItem: Hashable, Identifiable, CustomStringConvertible {
    var id: Self { self }
    var name: String
    var children: [FileItem]? = nil
    var description: String {
        switch children {
        case nil:
            return "\(name)"
        case .some(_):
            return "\(name)"
        }
    }
}

struct CategoryView: View {
    var body: some View {
        NavigationStack {
            List(categoryData, children: \.children) { item in
                Text(item.description)
            }
            .navigationTitle("分类")
        }
    }
}


#Preview {
    CategoryView()
}
