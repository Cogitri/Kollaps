//
//  SendCodeView.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 05.05.23.
//

import SwiftUI

private enum ViewState {
    case done
    case error(NSError)
    case prepare
}

struct SendCodeView: View {
    @Binding var code: String
    @State private var isInitialised = false
    @State private var state = ViewState.prepare
    let sender: SenderBase

    var body: some View {
        VStack {
            switch state {
            case .prepare:
                Text("Your Transmit Code")
                    .font(.title)
                    .padding()

                Text("The receiver needs to enter the code \"\(code)\" to begin the file transfer.")

                Button("Copy code") {
                    self.copyCode()
                }

                ProgressView()
            case .done:
                Text("Succesfully transfered the file to the peer.")
            case .error(let msg):
                Text("Couldn't send file due to error \(msg.localizedDescription)")
            }
        }.task({
            await startSending()
        })
    }

    func copyCode() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(code, forType: .string)
    }

    func startSending() async {
        if isInitialised {
            return
        }
        isInitialised = true

        Task.detached {
            do {
                try await sender.finish()
                state = .done
            } catch let error as NSError {
                state = .error(error)
            }
        }
    }
}
