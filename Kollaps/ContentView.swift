//
//  ContentView.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 08.04.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ReceiveView().tabItem({ Text("Receive Data") })
            SendView().tabItem({ Text("Send Data") })
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
