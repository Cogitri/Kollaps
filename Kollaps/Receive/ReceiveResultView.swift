//
//  ReceiveResultView.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 03.05.23.
//

import SwiftUI
import WormholeWilliam

private enum ViewState {
    case done
    case error(NSError)
    case prepare
}

struct ReceiveResultView: View {
    @State var ctx: ReceiverBase
    @State var url: URL
    @State private var isInitialised = false
    @State private var state = ViewState.prepare

    var body: some View {
        VStack {
            switch state {
            case .prepare:
                Text("Receiving data...")
                ProgressView()
            case .done:
                Text("Successfully received file.")
            case .error(let msg):
                Text("Couldn't receive file due to error \(msg.localizedDescription).")
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

        do {
            try (ctx as! ReceiverFile).finish(url)
            state = .done
        } catch let msg as NSError {
            state = .error(msg)
        }
    }
}
