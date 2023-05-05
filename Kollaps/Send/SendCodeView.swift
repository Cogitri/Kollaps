//
//  SendCodeView.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 05.05.23.
//

import SwiftUI
import WormholeWilliam

struct SendCodeView: View {
    @Binding var code: String
    @State private var error: NSError?
    @State private var isInitialised = false
    let sender: SenderBase

    var body: some View {
        VStack {
            if let msg = error {
                Text("Couldn't send file due to error \(msg)")
            } else {
                Text("Your Transmit Code")
                    .font(.title)
                    .padding()

                Text("The receiver needs to enter the code \"\(code)\" to begin the file transfer.")

                Button("Copy code") {
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(code, forType: .string)
                }

                ProgressView()
            }
        }.task({
            startSending()
        })
    }

    func startSending() {
        if isInitialised {
            return
        }
        isInitialised = true

        do {
            try sender.finish()
        } catch let error as NSError {
            self.error = error
        }
    }
}
