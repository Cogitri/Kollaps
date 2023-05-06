//
//  ReceiverFile.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 06.05.23.
//

import Foundation
import WormholeWilliam

class ReceiverFile : ReceiverBase {
    func finish(_ url: URL) throws {
        var error: NSError?
        WormholeWilliamReceiverContextReceiveFile(ctx, url.path(), &error)

        if let msg = error {
            throw msg
        }
    }
}
