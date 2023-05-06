//
//  ReceiveConfirmView.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 25.04.23.
//

import SwiftUI
import WormholeWilliam

private enum ViewState {
    case done
    case error(NSError)
    case prepare
}

struct ReceiveConfirmView: View {
    @State private var size: Int64 = 0
    @State private var fileName: String?
    @State fileprivate var isInitialised = false
    @State fileprivate var state = ViewState.prepare
    let ctx: ReceiverBase
    let code: String
    @Binding var url: URL?
    let onChangeFunc: (Bool) -> Void

    var humanSize: String {
        let formatter = ByteCountFormatter()
        return formatter.string(fromByteCount: self.size * 1000)
    }

    var body: some View {
        VStack {
            switch state {
            case .prepare:
                    ProgressView()
            case .done:
                Text("Your peer wants to send you \"\(self.fileName ?? "Unknown")\" (size: \(self.humanSize)).")
                HStack {
                    Button("Accept", action: {
                        var url = self.openFileSelector()
                        if let uri = url {
                            url = uri.appendingPathComponent(fileName ?? "Unknown")
                            self.onChangeFunc(true)
                        }
                        self.url = url
                    })
                    Button("Decline", action: {
                        self.onChangeFunc(false)
                    })
                }
            case .error(let msg):
                Text("Couldn't initialise receiver: \(msg.localizedDescription)")
            }
        }
        .task({
            await self.fetchData()
        })
    }

    func fetchData() async {
        if isInitialised {
            return
        }
        isInitialised = true

        do {
            try await ctx.prepare(code: code)
            self.size = ctx.fileSize
            self.fileName = ctx.fileName
            state = .done
        } catch let error as NSError {
            state = .error(error)

        }
    }

    private func openFileSelector() -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        let response = openPanel.runModal()
        return response == .OK ? openPanel.url : nil
    }
}

struct ReceiveConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        let view = ReceiveConfirmView(
            ctx: ReceiverFile(),
            code: "7-crossover-clockwork",
            url: .constant(URL(string: "/dev/null")),
            onChangeFunc: { _ in }
        )
        view.state = ViewState.done
        view.isInitialised = true
        return view
    }
}
