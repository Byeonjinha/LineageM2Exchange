//
//  ServerItemStaticsView.swift
//  lineage2M
//
//  Created by Byeon jinha on 2022/12/29.
//


import SwiftUI

struct ServerItemStaticsView: View {
    @StateObject private var searchServerItemValueStaticsByCondition = SearchServerItemValueStatisticsAPI.shared
    var body: some View {
        VStack {
            Text("서버 거래소")
                .padding(.leading)
                .frame(width: UIScreen.main.bounds.width*0.5, alignment: .leading)
            if !searchServerItemValueStaticsByCondition.posts.isEmpty {
                let enchantLevel = Double(searchServerItemValueStaticsByCondition.posts[0].enchantLevel)
                let now = searchServerItemValueStaticsByCondition.posts[0].now?.unitPrice ?? 0
                let last = searchServerItemValueStaticsByCondition.posts[0].last?.unitPrice ?? 0
                let min = searchServerItemValueStaticsByCondition.posts[0].min?.unitPrice ?? 0
                let max = searchServerItemValueStaticsByCondition.posts[0].max?.unitPrice ?? 0
                let avg = searchServerItemValueStaticsByCondition.posts[0].avg?.unitPrice ?? 0
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
