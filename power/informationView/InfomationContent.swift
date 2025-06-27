//
//  InfomationContent.swift
//  power
//
//  Created by 胡杰 on 2025/6/23.
//

import SwiftUI

struct InfomationContent: View {
    let inputDevice: InformationViewDevice?
    var body: some View {
        VStack(spacing: 15){
            VStack{
                if let param = inputDevice?.name,!param.isEmpty {
                    Text("\(param)")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            VStack{
                if let param = inputDevice?.brand,!param.isEmpty {
                    Text("品牌")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(param)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            VStack{
                if let param = inputDevice?.model,!param.isEmpty {
                    Text("型号")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(param)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            VStack{
                if let param = inputDevice?.size,!param.isEmpty {
                    Text("尺寸")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(param)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            VStack{
                if let param = inputDevice?.weight,!param.isNaN {
                    Text("重量")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(param)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            VStack{
                if let param = inputDevice?.capacity,!param.isEmpty {
                    Text("容量")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(param)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            VStack{
                if let param = inputDevice?.type,!param.isEmpty {
                    Text("类型")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ScrollView(.horizontal){
                        HStack() {
                            ForEach(param, id: \.self) { item in
                                Button(
                                    action: {
                                        
                                    }) {
                                        Text(item)
                                            .padding(10)
                                    }
                                    .background(.gray.opacity(0.2))
                                    .cornerRadius(30)
                                    .foregroundStyle(.primary)
                            }
                        }
                        .frame(maxWidth: .infinity,alignment: .leading)
                    }

                }
            }
            VStack{
                if let param = inputDevice?.input,!param.isEmpty {
                    Text("输入功率")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ScrollView(.horizontal){
                        HStack() {
                            ForEach(param, id: \.self) { item in
                                Button(
                                    action: {
                                        
                                    }) {
                                        Text(item)
                                            .padding(10)
                                    }
                                    .background(.gray.opacity(0.2))
                                    .cornerRadius(30)
                                    .foregroundStyle(.primary)
                            }
                        }
                        .frame(maxWidth: .infinity,alignment: .leading)
                    }
                }
            }
            VStack{
                if let param = inputDevice?.output,!param.isEmpty {
                    Text("输出功率")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ScrollView(.horizontal){
                        HStack() {
                            ForEach(param, id: \.self) { item in
                                Button(
                                    action: {
                                        
                                    }) {
                                        Text(item)
                                            .padding(10)
                                    }
                                    .background(.gray.opacity(0.2))
                                    .cornerRadius(30)
                                    .foregroundStyle(.primary)
                            }
                        }
                        .frame(maxWidth: .infinity,alignment: .leading)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    DeviceView()
}
