//
//  ReceiveConfirmView.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 25.04.23.
//

import SwiftUI
import WormholeWilliam

struct ReceiveConfirmView : View {
    @State var size: Int64 = 0;
    @State var fileName: String? = nil;
    @State var error: NSError? = nil;
    @Binding var url: URL?;
    let onChangeFunc: (Bool) -> Void;
    
    var body: some View {
        VStack {
            if error != nil {
                Text("Couldn't initialise receiver: \(error!)")
            } else if size != 0 && fileName != nil {
                Text("Your peer wants to send you \"\(self.fileName ?? "Unknown")\" (size: \(self.size)).")
                HStack {
                    Button("Accept", action: {
                        self.onChangeFunc(true);
                        self.url = self.openFileSelector()
                    })
                    Button("Decline", action: {
                        self.onChangeFunc(false);
                    })
                }
            } else {
                ProgressView()
            }
        }
    }
    
    @MainActor
    func updateUI(_ size: Int64, _ fileName: String?, _ error: NSError?) async {
        if let e = error {
            self.error = e;
        } else {
            self.size = size;
            self.fileName = fileName;
        }
    }
    
    func fetchData(_ ctx: WormholeWilliamReceiverContext, _ code: String) {
        Task.detached {
            var error: NSError? = nil;
            WormholeWilliamReceiverContextInitReceive(ctx, code, &error);
            if error != nil {
                await self.updateUI(0, nil, error);
            } else {
                let size = WormholeWilliamReceiverContextGetSize(ctx);
                let fileName = WormholeWilliamReceiverContextGetName(ctx);
                await self.updateUI(size, fileName, error);
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

