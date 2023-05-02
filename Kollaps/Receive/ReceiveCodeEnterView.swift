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
    var doneCallback = {}

    var body: some View {
        VStack {
            Image(systemName: "arrow.down.circle")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .padding()
            
            Text("Receive data")
                .font(.title)

            TextField("Receive code", text: $code, prompt: Text("Receive code (e.g. 7-crossover-clockwork)"))
                .onSubmit {
                    validateCode()
                }
                .frame(width: 350)
            
            if isError {
                Text("Code is invalid!");
            }
            
            Button("Next", action: {
                validateCode()
            })
        }
        .padding()
    }
    
    func onCompleted(_ action: @escaping () -> Void) -> Self {
        var copy = self;
        copy.doneCallback = action
        return copy
    }
    
    private func validateCode() {
        print(code)
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
        ReceiveCodeEnterView(code: .constant("7-crossover-clockwork"));
    }
}
