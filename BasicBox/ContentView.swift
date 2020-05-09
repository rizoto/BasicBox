//
//  ContentView.swift
//  BasicBox
//
//  Created by Lubor Kolacny on 1/5/20.
//  Copyright © 2020 Lubor Kolacny. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var showingDetail = false
    var body: some View {
        VStack() {
            HStack() {
                Button(action: {
                    self.showingDetail.toggle()
                }) {
                    Text("Config")
                }.popover(isPresented: $showingDetail) {
                    DetailView(isPresented: self.$showingDetail)
                }.padding()
                   
                Spacer()
            }
            Spacer()
        }
    }
}


struct DetailView: View {
    @State var demoToken: String = ""
    @State var liveToken: String = ""
    @Binding var isPresented: Bool
    var body: some View {
        Form {
            Text("Demo Token:")
            TextField("", text: $demoToken)
            Text("Live Token:")
            TextField("", text: $liveToken)
            HStack {
                Button(action: {
                    self.isPresented = false
                }) {
                    Text("Cancel")
                }
                Button(action: {
                    let tokens = TokenManager().fetchTokens()
                    self.demoToken = tokens.0
                    self.liveToken = tokens.1
                }) {
                    Text("Load")
                }
                Button(action: {
                    TokenManager().saveTokens(demoToken: self.demoToken, liveToken: self.liveToken)
                    self.isPresented = false
                }) {
                    Text("Save")
                }
            }
        }.padding(.horizontal, 5.0).frame(width: 350.0, height: 300.0)
    }
}

