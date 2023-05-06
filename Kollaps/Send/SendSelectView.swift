//
//  SendSelectView.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 05.05.23.
//

import SwiftUI

struct SendSelectView: View {
    @Binding var code: String
    let sender: SenderBase
    @State private var isPreparing = false

    var body: some View {
        VStack {
            Image(systemName: "arrow.up.circle")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .padding()

            Text("Send data")
                .font(.title)

            Button(
                action: {
                    isPreparing = true
                    let url = openFileSelector()
                    if url != nil {
                        Task {
                            await sendUrl(url!)
                            isPreparing = false
                        }
                    }
                },
                label: {
                    ZStack {
                        Text("Select data to send").opacity(isPreparing ? 0 : 1)

                        if isPreparing {
                            ProgressView()
                        }
                    }
                }
            ).disabled(isPreparing)
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
        let code = try? await sender.prepare(con: url.path())
        if code != nil {
            self.code = code!
        }
    }
}
