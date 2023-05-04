//
//  ContentView.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 21.04.23.
//

import SwiftUI

struct SendView: View {
    @State private var code = ""

    var body: some View {
        if code == "" {
            SendSelectView(code: $code)
        } else {
            SendCodeView(code: $code)
        }
    }
}

struct SendSelectView: View {
    @Binding var code: String

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
        let sender = SenderText()
        let code = try? sender.prepare(con: url.absoluteString)
        if code != nil {
            self.code = code!
        }
    }
}

struct SendCodeView: View {
    @Binding var code: String

    var body: some View {
        Text("Your Transmit Code")
            .font(.title)

        Text("The receiver needs to enter the code \"\(code)\" to begin the file transfer.")
    }
}

struct SendView_Previews: PreviewProvider {
    static var previews: some View {
        SendView()
    }
}
