//
//  ContentView.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 21.04.23.
//

import SwiftUI

struct SendView: View {
    @State private var code = ""
    let sender: SenderBase = SenderFile()

    var body: some View {
        VStack {
            if code.isEmpty {
                SendSelectView(code: $code, sender: sender)
            } else {
                SendCodeView(code: $code, sender: sender)
            }
        }
    }
}

struct SendView_Previews: PreviewProvider {
    static var previews: some View {
        SendView()
    }
}
