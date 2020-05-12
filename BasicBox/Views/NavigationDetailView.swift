//
//  NavigationDetailView.swift
//  BasicBox
//
//  Created by Lubor Kolacny on 9/5/20.
//  Copyright © 2020 Lubor Kolacny. All rights reserved.
//

import SwiftUI

struct NavigationDetailView: View {
    let instrument: String
    @ObservedObject var viewModel = DetailViewViewModel()
    var body: some View {
        GeometryReader {_ in
            VStack {
                Text(self.instrument)
                Text(String(self.viewModel.candles.count))
                Button("Run",action: {self.viewModel.fetchInstrument(instrument: self.instrument)})
                CandleBarChartView(candles: self.viewModel.graphDataSource)
            }
        }
    }
}
