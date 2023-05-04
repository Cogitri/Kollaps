//
//  SenderText.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 06.04.23.
//

import Foundation
import WormholeWilliam

class SenderText: SenderBase {
    func prepare(con text: String) throws -> String {
        var error: NSError?
        WormholeWilliamPrepareSendText(self.ctx, text, &error)
        if let error {
            throw error
        }
        return self.code
    }
}
