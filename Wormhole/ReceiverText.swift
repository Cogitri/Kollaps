//
//  ReceiverText.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 06.05.23.
//

import Foundation
import WormholeWilliam

class ReceiverText : ReceiverBase {
    func finish() throws -> String {
        var error: NSError?
        let text = WormholeWilliamReceiverContextReceiveText(ctx, &error)
        
        if let msg = error {
            throw msg
        }
        return text
    }
}
