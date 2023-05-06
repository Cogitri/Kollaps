//
//  ReceiveFileView.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 25.04.23.
//

import SwiftUI
import WormholeWilliam

struct ReceiveFileView: View {
    let ctx: WormholeWilliamReceiverContext
    let code: String
    let url: String
    private var done = false

    init(ctx: WormholeWilliamReceiverContext, code: String, url: String) {
        self.ctx = ctx
        self.code = code
        self.url = url

        self.receiveData()
        self.done = true
    }

    var body: some View {
        if done {
            Text("Done receiving data...")
        } else {
            Text("Receiving data...")

        }
    }

    func receiveData() {
        var error: NSError?
        WormholeWilliamReceiverContextReceiveFile(ctx, url, &error)

    }
}
