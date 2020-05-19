//
//  InstrumentsList.swift
//  BasicBox
//
//  Created by Lubor Kolacny on 9/5/20.
//  Copyright © 2020 Lubor Kolacny. All rights reserved.
//

import SwiftUI

struct InstrumentsList: View {
    @Binding var selectedRow: String?
//    @ObservedObject var instruments = InstrumentsViewModel()
    @EnvironmentObject private var data: DataManager
    var body: some View {
        List(data.instruments.allSorted, id: \.self,selection: $selectedRow) { instrument in
            InstrumentRow(instrument: instrument)
        }
    }
}

struct InstrumentRow: View {
    let instrument: String
    var body: some View {
        Text(instrument)
    }
}
