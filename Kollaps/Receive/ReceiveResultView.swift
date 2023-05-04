//
//  ReceiveResultView.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 03.05.23.
//

import SwiftUI
import WormholeWilliam

struct ReceiveResultView: View {
    @State private var error: NSError?
    @State var ctx: WormholeWilliamReceiverContext
    @State var url: URL
    @State var isInitialised = false
    @State var isDone = false

    var body: some View {
        VStack {
            if !isDone {
                ProgressView()
            } else {
                if let msg = error {
                    Text("Couldn't receive file due to error \(msg).")
                } else {
                    Text("Successfully received file.")
                }
            }
        }
        .task({
            self.finishReceive()
        })
    }

    func finishReceive() {
        if isInitialised {
            return
        }
        isInitialised = true

        var error: NSError?
        WormholeWilliamReceiverContextReceiveFile(ctx, url.path(), &error)
        self.error = error
        isDone = true
    }
}
