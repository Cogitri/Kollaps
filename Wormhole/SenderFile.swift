//
//  SenderFile.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 21.04.23.
//

import Foundation
import WormholeWilliam

class SenderFile: SenderBase {
    func prepare(con text: String) async throws -> String {
        let task = Task.detached {
            var error: NSError?
            WormholeWilliamPrepareSendFile(self.ctx, text, &error)
            if let error {
                throw error
            }
            return self.code
        }
        return try await task.value
    }
}
