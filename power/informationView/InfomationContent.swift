//
//  InfomationContent.swift
//  power
//
//  Created by 胡杰 on 2025/6/23.
//

import SwiftUI

// MARK: - 主视图
struct InfomationContent: View {
    let inputDevice: InformationViewDevice?
    
    @State private var showModal = false
    @State private var showAddSheet = false
    
    @State private var selectedFeature: FeatureItem? = nil

    var body: some View {
        VStack(spacing: 15) {
            // 名称
            if let param = inputDevice?.name, !param.isEmpty {
                Text(param)
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            // 品牌
            if let param = inputDevice?.brand, !param.isEmpty {
                VStack(alignment: .leading) {
                    Text("品牌")
                        .font(.title2)
                        .bold()
                    Text(param)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // 型号
            if let param = inputDevice?.model, !param.isEmpty {
                VStack(alignment: .leading) {
                    Text("型号")
                        .font(.title2)
                        .bold()
                    Text(param)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // 特点
            if let param = inputDevice?.type, !param.isEmpty {
                VStack(alignment: .leading) {
                    Text("特点")
                        .font(.title2)
                        .bold()
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(param, id: \.self) { item in
                                Button {
                                    if featureDescription(for: item) != "暂无" {
                                        selectedFeature = FeatureItem(name: item)
                                    }
                                } label: {
                                    Text(item)
                                        .padding(10)
                                        .background(.gray.opacity(0.2))
                                        .cornerRadius(30)
                                        .foregroundStyle(.primary)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }

            // 显示详细信息按钮
            HStack(spacing: 20) {
                Button(action: {
                    showModal = true
                }) {
                    Label("详细", systemImage: "info.circle")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(25)
                }

                Button(action: {
//                    shareDevice()
                }) {
                    Label("分享", systemImage: "square.and.arrow.up")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.green.opacity(0.1))
                        .foregroundColor(.green)
                        .cornerRadius(25)
                }
            }
            .padding(.top, 10)
        }
        .padding()
        
        // 详细信息弹窗
        .sheet(isPresented: $showModal) {
            DeviceDetailSheet(inputDevice: inputDevice)
        }

        // 特点弹窗
        .sheet(item: $selectedFeature) { feature in
            FeatureDetailSheet(feature: feature.name)
        }
    }
}

// MARK: - 特点
struct FeatureDetailSheet: View {
    let feature: String

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 16)

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "bolt.horizontal.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.indigo)
                    Spacer()
                }

                Text(feature)
                    .font(.title2)
                    .bold()

                Text("协议")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(featureDescription(for: feature))
                    .font(.body)
                    .lineSpacing(6)

                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(uiColor: .systemBackground))
            )
            .padding(.horizontal)
            .padding(.top, 8)

            Spacer()
        }
        .background(Color.black.opacity(0.01))
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - 详细信息
struct DeviceDetailSheet: View {
    let inputDevice: InformationViewDevice?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let param = inputDevice?.size, !param.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("尺寸")
                            .font(.title2)
                            .bold()
                        Text(param)
                    }
                }

                if let weight = inputDevice?.weight, !weight.isNaN {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("重量")
                            .font(.title2)
                            .bold()
                        Text(weight == 0 ? "暂无" : "\(String(format: "%.2f", weight)) 克")
                    }
                }

                if let param = inputDevice?.capacity, !param.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("容量")
                            .font(.title2)
                            .bold()
                        Text(param)
                    }
                }

                if let param = inputDevice?.input, !param.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("输入功率")
                            .font(.title2)
                            .bold()
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(param, id: \.self) { item in
                                    Text(item)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                }

                if let param = inputDevice?.output, !param.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("输出功率")
                            .font(.title2)
                            .bold()
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(param, id: \.self) { item in
                                    Text(item)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .presentationDetents([.medium, .large])
    }
}

// MARK: - 特点说明
func featureDescription(for feature: String) -> String {
    switch feature {
    case "PD":
        return """
        PD接口，即“Power Delivery电力传输协议”，是一种通过Type-C接口进行快充的标准技术。
        它可根据设备需求自动调整电压与电流，实现更快速、安全的充电。
        例如，手机、平板、笔记本电脑都可共用一个PD充电器，不仅方便还减少了多个充电器的麻烦。
        普通消费者在选购充电器或充电宝时，只要看到“支持PD快充”，就说明它能为设备提供高效的电力支持，是值得优先考虑的充电方案。
        """

    case "Apple":
        return """
        Apple的快充协议主要是基于PD标准，同时配合自家认证的MFi（Made for iPhone）配件认证。
        使用支持PD协议和MFi认证的充电器和数据线，可以为iPhone、iPad等设备实现更快、更安全的充电体验。
        普通消费者在选购充电器时，建议优先选择支持PD且有MFi标志的产品，以确保兼容性和设备安全。
        """

    case "BC":
        return """
        BC协议，全称为Battery Charging Specification，是USB组织推出的基础充电标准。
        它定义了USB接口的充电方式，常见于传统USB-A接口的设备上。
        BC协议支持最高5V 1.5A的输出，适用于多数低功耗设备如手机、耳机等。
        虽然速度不及PD或QC，但兼容性强、稳定性好。
        普通消费者使用电脑USB口或老式充电器时，多数就是通过BC协议进行充电。
        """

    case "FCP":
        return """
        FCP（Fast Charging Protocol）是华为推出的一种快充协议，常用于中端及早期华为设备。
        它通常支持9V 2A的输出，能显著提升充电速度。
        相比普通5V充电器，FCP能更快地为手机补充电量。
        消费者在使用华为设备时，选购支持FCP协议的充电器和数据线，可以获得更快更稳定的充电体验，提升日常使用便利性。
        """

    case "Mipps":
        return """
        MiPPS协议是小米基于USB PD和PPS标准开发的快充技术，广泛应用于小米手机、平板和笔记本等设备上。
        它支持更高功率和智能电压调节，使充电更快、更安全。
        使用支持MiPPS的充电器，可以大幅缩短充电时间。
        普通消费者在选购充电器或充电宝时，建议选择支持PD/PPS协议的产品，以获得更好的兼容性和快充体验。
        """

    case "PPS":
        return """
        PPS是一种更智能的快充协议，是PD协议的升级版。
        它能根据设备的需求，动态调节电压和电流，实现更高效、更低发热的充电效果。
        很多安卓手机和部分笔记本都支持PPS协议。
        如果你想获得更快、更安全的充电体验，选购支持PPS的充电器是个不错的选择。
        """

    case "QC":
        return """
        QC协议（Quick Charge）是高通推出的一种快充技术，常见于安卓手机和部分电子设备。
        它通过提高电压或电流，缩短充电时间。
        使用支持QC的充电器和数据线，可以让设备在短时间内充入更多电量。
        消费者在选购充电器时，如果设备支持QC协议，选择QC认证产品能带来更快的充电体验，同时也更安全可靠。
        """

    case "Qi":
        return """
        Qi无线充电协议由无线电力联盟（WPC）推出，是目前主流的无线充电标准。
        该协议支持感应式充电，用户只需将设备放在支持Qi的充电底座上即可开始充电。
        广泛应用于手机、耳机和智能手表等设备。
        普通消费者在选购无线充电设备时，选择“支持Qi协议”的产品可以保证更好的兼容性和安全性。
        """

    case "SCP":
        return """
        SCP（SuperCharge Protocol）是华为推出的快充协议，常用于华为手机和部分平板。
        它通过较高电流（如4.5A或5A）实现快速、安全的充电，比普通充电速度更快。
        消费者在选购充电器或数据线时，若使用华为设备，建议选择支持SCP协议的原装或认证产品，以确保兼容性和充电效率，避免因不兼容导致充电慢或设备发热。
        """

    case "Type-C":
        return """
        Type-C协议指的是使用USB Type-C接口的通信和充电标准。这种接口形状小巧、支持正反插，使用方便。
        Type-C不仅能传输数据，还能支持高速充电和高清视频输出。
        很多现代手机、笔记本和电子设备都采用Type-C接口，带来更快的传输速度和更强的兼容性。
        普通消费者使用Type-C设备时，可以享受更便捷的连接和更高效的充电体验。
        """

    case "UFCS":
        return """
        UFCS协议是一种用于快速充电的通信标准，全称是“Universal Fast Charging Standard”（通用快充标准）。
        它让不同品牌的充电器和设备之间实现更高效、安全的充电兼容，减少充电时间，同时保护电池健康。
        普通用户使用支持UFCS协议的设备时，能享受更快、更稳定的充电体验，避免过热和损坏，是现代智能手机和平板电脑常用的快充技术之一。
        """

    case "USB-A":
        return """
        USB-A协议是最常见的USB接口标准，形状扁平且方向固定。
        它用于连接电脑、手机、鼠标、键盘等设备，实现数据传输和充电功能。
        虽然USB-A速度和功率不如新型接口，但其兼容性强，广泛应用于各种电子产品。
        普通用户通过USB-A接口可以方便地连接和充电多种设备，是日常生活中最常见的接口类型之一。
        """

    default:
        return "暂无"
    }
}

struct FeatureItem: Identifiable, Equatable {
    let id = UUID()
    let name: String
}


#Preview {
    DeviceView()
}
