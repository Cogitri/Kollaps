//
//  ContentView.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 08.04.23.
//

import SwiftUI
import WormholeWilliam

enum Destination : Hashable {
    case ConfirmView
    case ReceiveView
    case RejectedView
}

struct ReceiveView: View {
    @State private var code = "";
    @State private var codeEntered = false;
    @State private var isAccepted = false;
    @State private var ctx = WormholeWilliamNewReceiverContext();
    @State private var url: URL?;
    @State private var path = NavigationPath();
    
    var body: some View {
        NavigationStack(path: $path) {
            ReceiveCodeEnterView(code: $code, doneCallback: {
                path.append(Destination.ConfirmView)

            })
            .navigationDestination(for: Destination.self) { data in
                getViewForDestination(dest: data)
            }
            .navigationTitle("Receiver")
        }
    }
    
    
    @ViewBuilder
    func getViewForDestination(dest: Destination) -> some View {
        switch dest {
        case .ConfirmView:
            { () -> ReceiveConfirmView in
                let c = ReceiveConfirmView(url: $url) {
                    if $0 {
                        path.append(Destination.ReceiveView);
                    } else {
                        path.append(Destination.RejectedView)
                    }
                };
                c.fetchData(ctx!, code);
                return c
            }()
        case .ReceiveView:
            ReceiveView();
        case .RejectedView:
            Text("Rejected the transfer")
        }
    }
}


struct ReceiveView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiveView()
    }
}
