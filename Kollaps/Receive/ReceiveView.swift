//
//  ContentView.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 08.04.23.
//

import SwiftUI
import WormholeWilliam

enum Destination : Hashable {
    case CodeEnterView
    case ConfirmView
    case ReceiveView
    case RejectedView
    case ResultView
}

struct ReceiveView: View {
    @State private var code: String = "";
    @State private var codeEntered = false;
    @State private var isAccepted = false;
    @State private var ctx = WormholeWilliamNewReceiverContext();
    @State private var url: URL?;
    @State private var destination = Destination.CodeEnterView;
    
    var body: some View {
        switch self.destination {
        case .CodeEnterView: ReceiveCodeEnterView(code: $code).onCompleted {
            destination = .ConfirmView
        }
        case .ConfirmView:
            ReceiveConfirmView(ctx: ctx!, code: code, url: $url) {
                    if $0 {
                        destination = .ResultView;
                    } else {
                        destination = .RejectedView;
                    }
                }
        case .ReceiveView:
            ReceiveView();
        case .RejectedView:
            Text("Rejected the transfer")
        case .ResultView:
            ReceiveResultView(ctx: ctx!, url: url!)
        }
    }
}


struct ReceiveView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiveView()
    }
}
