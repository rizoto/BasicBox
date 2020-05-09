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
    var body: some View {
        GeometryReader {_ in
            VStack {
                Text(self.instrument)
                Button("Run",action: {helper().run_db()})
            }
        }
    }
}
