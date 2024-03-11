//
//  AppLoadingView.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/3/24.
//

import SwiftUI

struct AppLoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Loading View")
                .frame(maxWidth: .infinity)
            Spacer()
        }
        .background(Color(.systemGray6))
    }
}

#Preview {
    AppLoadingView()
}
