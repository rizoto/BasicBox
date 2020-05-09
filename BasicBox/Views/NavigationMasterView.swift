//
//  NavigationMasterView.swift
//  BasicBox
//
//  Created by Lubor Kolacny on 9/5/20.
//  Copyright © 2020 Lubor Kolacny. All rights reserved.
//

import SwiftUI

struct NavigationMasterView: View {
    @State var showingConfig = false
    @Binding var selectedRow: String?
    var body: some View {
        VStack() {
            HStack() {
                Button(action: {
                    self.showingConfig.toggle()
                }) {
                    Text("Config")
                }.popover(isPresented: $showingConfig) {
                    ConfigView(isPresented: self.$showingConfig)
                }.padding()
                   
                Spacer()
            }
            InstrumentsList(selectedRow: $selectedRow).listStyle(SidebarListStyle())
            Spacer()
        }.frame(minWidth: 150, maxWidth: 150)
    }
}
