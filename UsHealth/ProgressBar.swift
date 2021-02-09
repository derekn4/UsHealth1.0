//
//  ProgressBar.swift
//  UsHealth
//
//  Created by Derek Nguyen on 2/9/21.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var progress: Float
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.red)
        }
    }
}
