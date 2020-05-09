//
//  ContentView.swift
//  BasicBox
//
//  Created by Lubor Kolacny on 1/5/20.
//  Copyright © 2020 Lubor Kolacny. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedRow: String?
    var body: some View {
        NavigationView{
            NavigationMasterView(selectedRow: $selectedRow)
            if selectedRow != nil {
                NavigationDetailView(instrument: selectedRow!)
            }
        }.frame(minWidth: 700, minHeight: 400)
    }
}
