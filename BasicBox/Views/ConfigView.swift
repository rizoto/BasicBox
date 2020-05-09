//
//  ConfigView.swift
//  BasicBox
//
//  Created by Lubor Kolacny on 9/5/20.
//  Copyright © 2020 Lubor Kolacny. All rights reserved.
//

import SwiftUI

struct ConfigView: View {
    @State var demoToken: String = ""
    @State var liveToken: String = ""
    @State var demoAccount: String = ""
    @State var liveAccount: String = ""
    @Binding var isPresented: Bool
    var body: some View {
        Form {
            Section {
                Text("Demo Token:")
                TextField("", text: $demoToken)
                Text("Demo Account:")
                TextField("", text: $demoAccount)
            }
            Section {
                Text("Live Token:")
                TextField("", text: $liveToken)
                Text("Live Account:")
                TextField("", text: $liveAccount)
            }
            HStack {
                Button(action: {
                    self.isPresented = false
                }) {
                    Text("Cancel")
                }
                Button(action: {
                    let tokens = TokenManager().fetchTokens()
                    let accounts = TokenManager().fetchAccounts()
                    self.demoToken = tokens.0
                    self.liveToken = tokens.1
                    self.demoAccount = accounts.0
                    self.liveAccount = accounts.1
                }) {
                    Text("Load")
                }
                Button(action: {
                    TokenManager().saveTokens(demoToken: self.demoToken, liveToken: self.liveToken)
                    TokenManager().saveAccounts(demoAccount: self.demoAccount, liveAccount: self.liveAccount)
                    self.isPresented = false
                }) {
                    Text("Save")
                }
            }
        }.padding(.horizontal, 5.0).frame(width: 350.0, height: 300.0)
    }
}
