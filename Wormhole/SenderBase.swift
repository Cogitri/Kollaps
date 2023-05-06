//
//  SenderBase.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 06.04.23.
//

import Foundation
import WormholeWilliam

protocol SenderBaseProtocol {
    func prepare(con: String) async throws -> String
}

class SenderBaseClass {
    init() {
        self.ctx = WormholeWilliamNewSenderContext()!
    }

    public func finish() async throws {
        let task = Task.detached {
            var error: NSError?
            WormholeWilliamSenderContextFinishSend(self.ctx, &error)

            if let msg = error {
                throw msg
            }
        }
        return try await task.value
    }

    internal var code: String {
        return WormholeWilliamSenderContextGetCode(self.ctx)
    }

    internal var ctx: WormholeWilliamSenderContext
}

typealias SenderBase = SenderBaseClass & SenderBaseProtocol
