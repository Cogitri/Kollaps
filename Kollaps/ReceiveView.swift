//
//  ContentView.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 08.04.23.
//

import SwiftUI
import WormholeWilliam

struct ReceiveView: View {
    @State private var code = "";
    @State private var codeEntered = false;
    @State private var isAccepted = false;
    @State private var ctx = WormholeWilliamNewReceiverContext();
    @State private var url: String? = "";

    var body: some View {
        if codeEntered {
            if isAccepted {
                ReceiveFileView(ctx: self.ctx!, code: self.code, url: self.url!)
            } else {
                ReceiveConfirmView(
                    size: WormholeWilliamGetSize(self.ctx),
                    fileName: WormholeWilliamGetName(self.ctx),
                    onChangeFunc: {(x) in self.isAccepted = x;},
                    url: $url
                )
            }
        } else {
            ReceiveCodeEnterView(code: $code, isReceiving: $codeEntered)
        }
    }
    
    
    func change() {
        
    }
}

struct ReceiveConfirmView : View {
    let size: Int64;
    let fileName: String;
    var onChangeFunc: (Bool) -> Void;
    @Binding var url: String?;
    
    
    var body: some View {
        VStack {
            Text("Your peer wants to send you \"\(self.fileName)\" (size: \(self.size)).")
            HStack {
                Button("Accept", action: {
                    self.onChangeFunc(true);
                    self.url = self.openFileSelector()?.absoluteString
                })
                Button("Decline", action: {
                    self.onChangeFunc(false);
                })
            }
        }
    }

    
    func openFileSelector() -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        let response = openPanel.runModal()
        return response == .OK ? openPanel.url : nil
    }
}

struct ReceiveFileView : View {
    let ctx: WormholeWilliamReceiverContext;
    let code: String;
    let url: String;
    var done = false;

    init(ctx: WormholeWilliamReceiverContext, code: String, url: String) {
        self.ctx = ctx
        self.code = code
        self.url = url
        
        self.receiveData()
        self.done = true;
    }
    
    var body: some View {
        if done {
            Text("Done receiving data...")
        } else {
            Text("Receiving data...")
            
        }
    }
    
    func receiveData() {
        var error: NSError?;
        WormholeWilliamReceiveFile(ctx, url, &error);
        
    }
}

struct ReceiveCodeEnterView: View {
    @Binding var code: String;
    @Binding var isReceiving: Bool;

    var body: some View {
        VStack {
            Image(systemName: "arrow.down.circle")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .padding()
            
            Text("Receive data")
                .font(.title)

            TextField("Receive code", text: $code)
            
            Button("Next", action: {
                isReceiving = true;
            })
        }
        .padding()
    }
}


struct ReceiveView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiveView()
    }
}
