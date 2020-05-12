//
//  ContentView.swift
//  SwiftUICharts
//
//  Created by Lubor Kolacny on 27/9/19.
//  Copyright © 2019 Lubor Kolacny. All rights reserved.
//

import SwiftUI

struct Candle4Graph: Hashable {
    let o: CGFloat
    let c: CGFloat
    let l: CGFloat
    let h: CGFloat
    var color: Color {
        (o < c) ? .green : .red
    }
    var min: CGFloat {
        return Swift.min(Swift.min(o, c),Swift.min(l, h))
    }
    var max: CGFloat {
        return Swift.max(Swift.max(o, c),Swift.max(l, h))
    }
    var o1: CGFloat {
        return Swift.min(o,c)
    }
}

func c4gH(candles:[Candle4Graph]) -> (CGFloat,CGFloat) {
    if candles.count < 1 {return (0.0,0.0)}
    var min: CGFloat
    var max: CGFloat
    min = candles.first!.min
    max = candles.first!.max
    candles.forEach { (candle) in
        min = Swift.min(candle.min, min)
        max = Swift.max(candle.max, max)
    }
    return (min,max)
}

struct CandleBarChartView: View {
    let candles:[Candle4Graph]
    var min_max: (CGFloat,CGFloat) {
        return c4gH(candles: candles)
    }
    var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .top, spacing: 1) {
                ForEach(self.candles, id: \.self) { candle in
                    GeometryReader {proxy in
                        CandleLowHighLines(candle: candle, min_max: self.min_max).overlay(Rectangle().size(width: 9, height: self.candleHeight(candle: candle, toHeight: proxy.size.height)).offset(y: self.candleOffset(candle: candle, toHeight: proxy.size.height)).foregroundColor((candle as Candle4Graph).color))
                    }//.background(Color.orange)
                }
            }.rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
        }
    }
    
    func candleHeight(candle: Candle4Graph, toHeight: CGFloat) -> CGFloat {
        return abs((candle.o-candle.c) * (toHeight/(min_max.1 - min_max.0)))
    }
    func candleOffset(candle: Candle4Graph, toHeight: CGFloat) -> CGFloat {
        return (candle.o1 - min_max.0) * (toHeight/(min_max.1 - min_max.0))
    }
}

struct CandleLowHighLines: View {
    let candle: Candle4Graph
    let min_max: (CGFloat,CGFloat)
    var body: some View {
        GeometryReader {proxy in
            Capsule().size(width: 1, height: self.candleHeight(candle: self.candle, toHeight: proxy.size.height)).offset(y: self.candleOffset(candle: self.candle, toHeight: proxy.size.height)).foregroundColor(Color.black).offset(x: 4)
        }
    }
    func candleHeight(candle: Candle4Graph, toHeight: CGFloat) -> CGFloat {
        return abs((candle.l-candle.h) * (toHeight/(min_max.1 - min_max.0)))
    }
    func candleOffset(candle: Candle4Graph, toHeight: CGFloat) -> CGFloat {
        return (candle.l - min_max.0) * (toHeight/(min_max.1 - min_max.0))
    }
}

