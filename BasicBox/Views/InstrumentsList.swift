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
    @ObservedObject var instruments = InstrumentsViewModel()
    var body: some View {
        List(instruments.instruments, id: \.self,selection: $selectedRow) { instrument in
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
