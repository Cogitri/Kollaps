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
    @State private var transferDone = false
    let sender: SenderBase

    var body: some View {
        VStack {
            if let msg = error {
                Text("Couldn't send file due to error \(msg.localizedDescription)")
            } else if transferDone {
                Text("Succesfully transfered the file to the peer.")
            } else {
                Text("Your Transmit Code")
                    .font(.title)
                    .padding()

                Text("The receiver needs to enter the code \"\(code)\" to begin the file transfer.")

                Button("Copy code") {
                    self.copyCode()
                }

                ProgressView()
            }
        }.task({
            startSending()
        })
    }

    func copyCode() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(code, forType: .string)
    }

    @MainActor
    func updateUI(_ error: NSError? = nil) async {
        self.error = error
        self.transferDone = true
    }

    func startSending() {
        if isInitialised {
            return
        }
        isInitialised = true

        Task.detached {
            do {
                try sender.finish()
                await self.updateUI()
            } catch let error as NSError {
                await self.updateUI(error)
            }
        }
    }
}
