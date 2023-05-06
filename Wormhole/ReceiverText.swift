//
//  ReceiverText.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 06.05.23.
//

import Foundation
import WormholeWilliam

class ReceiverText: ReceiverBase {
    func finish() async throws -> String {
        let task = Task.detached {
            var error: NSError?
            let text = WormholeWilliamReceiverContextReceiveText(self.ctx, &error)

            if let msg = error {
                throw msg
            }
            return text
        }
        return try await task.value
    }
}
