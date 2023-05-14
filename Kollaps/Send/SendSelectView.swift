//
//  SendSelectView.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 05.05.23.
//

import SwiftUI

private enum ViewState {
    case error(NSError)
    case prepare
    case timeout
}

struct SendSelectView: View {
    @Binding var code: String
    let sender: SenderBase
    @State private var state = ViewState.prepare
    @State private var isPreparing = false

    var body: some View {
        VStack {
            Image(systemName: "arrow.up.circle")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .padding()

            Text("Send data")
                .font(.title)

            switch state {
            case .prepare:
                Button(
                    action: {
                        isPreparing = true
                        let url = openFileSelector()
                        if url != nil {
                            Task {
                                await sendUrl(url!)
                            }
                        }
                    },
                    label: {
                        if isPreparing {
                            ProgressView()
                        } else {
                            Text("Select data to send")
                        }
                    }
                ).disabled(isPreparing)
            case .error(let msg):
                Text("Couldn't initialise sender: \(msg.localizedDescription)")
            case .timeout:
                Text("Generating the transmission code takes longer than expected...Does your internet connection work?")
            }
        }
        .padding()
    }

    func openFileSelector() -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        let response = openPanel.runModal()
        return response == .OK ? openPanel.url : nil
    }

    func sendUrl(_ url: URL) async {
        Task {
            do {
                try await Task.sleep(nanoseconds: 10_000_000_000)
                state = .timeout
            } catch {}
        }

        do {
            self.code = try await sender.prepare(con: url.path())
        } catch let msg as NSError {
            state = .error(msg)
        }
    }
}
