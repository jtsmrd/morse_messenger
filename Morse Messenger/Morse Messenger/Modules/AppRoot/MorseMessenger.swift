//
//  MorseMessenger.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 2/27/24.
//

import SwiftUI
import SwiftData
import GoogleSignIn

@main
struct MorseMessenger: App {
        
    @State private var rootVM = RootViewModel()

    var body: some Scene {
        WindowGroup {
            RootView(rootVM: rootVM)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
                .preferredColorScheme(.light)
        }
    }
}
