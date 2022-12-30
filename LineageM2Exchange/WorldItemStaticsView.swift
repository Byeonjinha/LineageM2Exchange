//
//  WorldItemStaticsView.swift
//  lineage2M
//
//  Created by Byeon jinha on 2022/12/29.
//

import SwiftUI

struct WorldItemStaticsView: View {
    @StateObject private var searchWorldItemValueStaticsByCondition = SearchWorldItemValueStatisticsAPI.shared
    var body: some View {
        VStack {
            Text("월드 거래소")
                .padding(.leading)
                .frame(width: UIScreen.main.bounds.width*0.5, alignment: .leading)
            if !searchWorldItemValueStaticsByCondition.posts.isEmpty {
                let enchantLevel = Double(searchWorldItemValueStaticsByCondition.posts[0].enchantLevel)
                let now = searchWorldItemValueStaticsByCondition.posts[0].now?.unitPrice ?? 0
                let last = searchWorldItemValueStaticsByCondition.posts[0].last?.unitPrice ?? 0
                let min = searchWorldItemValueStaticsByCondition.posts[0].min?.unitPrice ?? 0
                let max = searchWorldItemValueStaticsByCondition.posts[0].max?.unitPrice ?? 0
                let avg = searchWorldItemValueStaticsByCondition.posts[0].avg?.unitPrice ?? 0
                let staticsTuple: [(String, Double)] = [("현재가", now), ("마지막 거래가", last), ("최저가", min), ("최고가", max), ("평균가", avg)]
                HStack {
                    Text("강화 수치")
                        .frame(width: UIScreen.main.bounds.width*0.22, alignment: .leading)
                    Text(String(format: "%.0f", enchantLevel))
                        .frame(width: UIScreen.main.bounds.width*0.2, alignment: .trailing)
                }
                ForEach (staticsTuple.indices, id:\.self) { idx in
                    HStack {
                        Text(staticsTuple[idx].0)
                            .frame(width: UIScreen.main.bounds.width*0.22, alignment: .leading)
                        if now.truncatingRemainder(dividingBy: 1) == 0 {
                            Text(String(format: "%.0f", staticsTuple[idx].1) + "D")
                                .frame(width: UIScreen.main.bounds.width*0.2, alignment: .trailing)
                        } else {
                            Text(String(format: "%.2f", staticsTuple[idx].1) + "D")
                                .frame(width: UIScreen.main.bounds.width*0.2, alignment: .trailing)
                        }
                    }
                }
            } else {
                let staticsTuple: [(String, Double)] = [("현재가", 0), ("마지막 거래가", 0), ("최저가", 0), ("최고가", 0), ("평균가", 0)]
                HStack {
                    Text("강화 수치")
                        .frame(width: UIScreen.main.bounds.width*0.22, alignment: .leading)
                    Text(String(format: "%.0f", 0))
                        .frame(width: UIScreen.main.bounds.width*0.2, alignment: .trailing)
                }
                ForEach (staticsTuple.indices, id:\.self) { idx in
                    HStack {
                        Text(staticsTuple[idx].0)
                            .frame(width: UIScreen.main.bounds.width*0.22, alignment: .leading)
                        Text("0D")
                            .frame(width: UIScreen.main.bounds.width*0.2, alignment: .trailing)
                    }
                }
                
            }
        }
    }
}
