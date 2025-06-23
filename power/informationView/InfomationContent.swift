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
