//
//  ContentView.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 08.04.23.
//

import SwiftUI
import WormholeWilliam

enum Destination: Hashable {
    case codeEnterView
    case confirmView
    case receiveView
    case rejectedView
    case resultView
}

struct ReceiveView: View {
    @State private var code: String = ""
    @State private var codeEntered = false
    @State private var isAccepted = false
    @State private var ctx = ReceiverFile()
    @State private var url: URL?
    @State private var destination = Destination.codeEnterView

    var body: some View {
        switch self.destination {
        case .codeEnterView: ReceiveCodeEnterView(code: $code).onCompleted {
            destination = .confirmView
        }
        case .confirmView:
            ReceiveConfirmView(ctx: ctx, code: code, url: $url) {
                    if $0 {
                        destination = .resultView
                    } else {
                        destination = .rejectedView
                    }
                }
        case .receiveView:
            ReceiveView()
        case .rejectedView:
            Text("Rejected the transfer")
        case .resultView:
            ReceiveResultView(ctx: ctx!, url: url!)
        }
    }
}

struct ReceiveView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiveView()
    }
}
