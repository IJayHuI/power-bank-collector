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
                 FileItem(name: "Belkin", children: nil)
                ]),
    FileItem(name: "功率", children:
                [FileItem(name: "private", children: nil),
                 FileItem(name: "private", children: nil)
                ]),
    FileItem(name: "协议", children:
                [FileItem(name: "private", children: nil),
                 FileItem(name: "private", children: nil)
                ]),
    FileItem(name: "类型", children:
                [FileItem(name: "private", children: nil),
                 FileItem(name: "private", children: nil)
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
