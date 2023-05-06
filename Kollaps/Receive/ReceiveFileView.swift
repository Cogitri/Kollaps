//
//  ReceiveFileView.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 25.04.23.
//

import SwiftUI

private enum ViewState {
    case done
    case error(NSError)
    case prepare
}

struct ReceiveFileView: View {
    let ctx: ReceiverBase
    let code: String
    let url: String
    @State private var state = ViewState.prepare

    init(ctx: ReceiverBase, code: String, url: String) {
        self.ctx = ctx
        self.code = code
        self.url = url

        self.receiveData()
    }

    var body: some View {
        VStack {
            switch state {
            case .prepare:
                Text("Receiving data...")
                ProgressView()
            case .done:
                Text("Done receiving data...")
            case .error(let msg):
                Text("Couldn't receive data due to error \(msg.localizedDescription)")
            }
        }
    }

    func receiveData() {
        do {
            try (ctx as! ReceiverFile).finish(url)
            state = ViewState.done
        } catch let msg as NSError {
            state = ViewState.error(msg)
        }

    }
}
