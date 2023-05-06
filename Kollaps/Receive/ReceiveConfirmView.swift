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
    @State private var isInitialised = false
    @State private var state = ViewState.prepare
    let ctx: WormholeWilliamReceiverContext
    let code: String
    @Binding var url: URL?
    let onChangeFunc: (Bool) -> Void

    var body: some View {
        VStack {
            switch state {
            case .prepare:
                    ProgressView()
            case .done:
                Text("Your peer wants to send you \"\(self.fileName ?? "Unknown")\" (size: \(self.size)MB).")
                HStack {
                    Button("Accept", action: {
                        var url = self.openFileSelector()
                        if let uri = url {
                            url = uri.appendingPathComponent(fileName ?? "Unknown")
                        }
                        self.url = url
                        self.onChangeFunc(true)
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
            self.fetchData(ctx, code)
        })
    }

    @MainActor
    func updateUI(_ error: NSError) async {
        state = .error(error)
    }

    @MainActor
    func updateUI(_ size: Int64, _ filename: String) {
        self.size = size
        self.fileName = fileName
        state = .done
    }

    func fetchData(_ ctx: WormholeWilliamReceiverContext, _ code: String) {
        if isInitialised {
            return
        }
        isInitialised = true

        Task.detached {
            var error: NSError?
            WormholeWilliamReceiverContextInit(ctx, code, &error)
            if let msg = error {
                await self.updateUI(msg)
            } else {
                let size = WormholeWilliamReceiverContextGetSize(ctx)
                let fileName = WormholeWilliamReceiverContextGetName(ctx)
                await self.updateUI(size, fileName)
            }
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
