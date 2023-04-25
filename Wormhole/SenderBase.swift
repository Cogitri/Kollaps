//
//  SenderBase.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 06.04.23.
//

import Foundation
import WormholeWilliam

protocol SenderBaseProtocol {
    func prepare(con: String) throws -> String;
}

class SenderBaseClass {
    init() {
        self.ctx = WormholeWilliamNewSenderContext()!;
    }

    public func finish() {
        var error: NSError?;
        WormholeWilliamFinishSend(ctx, &error);
    }
    
    internal var code: String {
        return WormholeWilliamGetCode(self.ctx);
    }
    
    internal var ctx: WormholeWilliamSenderContext;
}

typealias SenderBase = SenderBaseClass & SenderBaseProtocol
