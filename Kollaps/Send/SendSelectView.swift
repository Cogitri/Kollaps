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

    var body: some View {
        VStack {
            Image(systemName: "arrow.up.circle")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .padding()

            Text("Send data")
                .font(.title)

            Button("Select data to send", action: {
                let url = openFileSelector()
                if url != nil {
                    sendUrl(url!)
                }
            })
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

    func sendUrl(_ url: URL) {
        let code = try? sender.prepare(con: url.path())
        if code != nil {
            self.code = code!
        }
    }
}
