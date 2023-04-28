//
//  ReceiveCodeEnterView.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 25.04.23.
//

import SwiftUI

struct ReceiveCodeEnterView: View {
    @State private var isError = false;
    @Binding var code: String;
    var doneCallback: () -> Void;

    var body: some View {
        VStack {
            Image(systemName: "arrow.down.circle")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .padding()
            
            Text("Receive data")
                .font(.title)

            TextField("Receive code", text: $code)
            
            if isError {
                Text("Code is invalid!");
            }
            
            Button("Next", action: {
                print(code)
                validateCode()
            })
        }
        .padding()
    }
    
    private func validateCode() {
        let passwordRegex = /[0-9]-[a-z]+-[a-z]+/
        if (code.contains(passwordRegex)) {
            doneCallback();
        } else {
            isError = true;
        }
    }
}


struct ReceiveCodeEnterView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiveCodeEnterView(code: .constant("Test"), doneCallback: {});
    }
}
