//
//  MorseCodeButton.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/7/24.
//

import UIKit
import SwiftUI

final class MorseCodeButton: UIViewRepresentable {
    typealias UIViewType = UIButton
    
    private var startTime = DispatchTime.now()
    private var endTime = DispatchTime.now()
    
    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle("Press me", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        
        button.addTarget(self, action: #selector(buttonTouchBegan(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchEnded(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc func buttonTouchBegan(_ sender: UIButton) {
        startTime = DispatchTime.now()
        
        // Start sound
    }
    
    @objc func buttonTouchEnded(_ sender: UIButton) {
        endTime = DispatchTime.now()
        
        // End sound
    }
    
    private func getElapsedTime() {
        
        let elapsedTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
        let elapsedTimeInMilliSeconds = Double(elapsedTime) / 1_000_000.0
        
        print(elapsedTimeInMilliSeconds)
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {
        
    }
    
    func measureElapsedTime(_ operation: () throws -> Void) throws -> UInt64 {
        let startTime = DispatchTime.now()
        try operation()
        let endTime = DispatchTime.now()

        let elapsedTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
        let elapsedTimeInMilliSeconds = Double(elapsedTime) / 1_000_000.0

        return UInt64(elapsedTimeInMilliSeconds)
    }
    
    func measureElapsedTime(_ operation: () throws -> Void) throws -> Double {
        let startTime = DispatchTime.now()
        try operation()
        let endTime = DispatchTime.now()

        let elapsedTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
        
        return Double(elapsedTime) / 1_000_000_000
    }
}
