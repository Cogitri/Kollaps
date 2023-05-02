//
//  ReceiveConfirmView.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 25.04.23.
//

import SwiftUI
import WormholeWilliam
import SwifterSwift

struct ReceiveConfirmView : View {
    @State var size: Int64 = 0;
    @State var fileName: String? = nil;
    @State var error: NSError? = nil;
    let ctx: WormholeWilliamReceiverContext;
    let code: String;
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
        .task({
            self.fetchData(ctx, code)
        })
    }
    
    @MainActor
    func updateUI(size: Int64 = 0, fileName: String? = nil, error: NSError? = nil) async {
        self.error = error;
        self.size = size;
        self.fileName = fileName;
    }
    
    func fetchData(_ ctx: WormholeWilliamReceiverContext, _ code: String) {
        Task.detached {
            var error: NSError? = nil;
            WormholeWilliamReceiverContextInitReceive(ctx, code, &error);
            if error != nil {
                await self.updateUI(error: error);
            } else {
                let size = WormholeWilliamReceiverContextGetSize(ctx);
                let fileName = WormholeWilliamReceiverContextGetName(ctx);
                await self.updateUI(size: size, fileName: fileName);
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

