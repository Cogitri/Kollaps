//
//  ReceiverBase.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 06.05.23.
//

import Foundation
import WormholeWilliam

class RecevierBaseClass {
    init() {
        self.ctx = WormholeWilliamNewReceiverContext()!
    }

    public func prepare(code: String) throws {
        var error: NSError?
        WormholeWilliamReceiverContextInit(ctx, code, &error)

        if let msg = error {
            throw msg
        }
    }

    var fileSize: Int64 {
        return WormholeWilliamReceiverContextGetSize(ctx)
    }

    var fileName: String {
        WormholeWilliamReceiverContextGetName(ctx)
    }

    internal var ctx: WormholeWilliamReceiverContext
}

typealias ReceiverBase = RecevierBaseClass
