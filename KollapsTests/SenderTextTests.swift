//
//  SenderTextTests.swift
//  KollapsTests
//
//  Created by Rasmus Thomsen on 08.04.23.
//

import Quick
import Nimble
@testable import Kollaps

class SenderTextTests: QuickSpec {
  override func spec() {
      describe("The 'SenderText'") {
          var sender: SenderText!
          beforeEach {
              sender = SenderText()
          }

          it("contains a code after preparing") {
              let code = try await sender.prepare(con: "test")
              expect {code}.to(match("[0-9]-[a-z]+-[a-z]+"))
          }

          it("correctly sends and receives a text") {
              let originalMessage = "test"
              let code = try await sender.prepare(con: originalMessage)
              let receiver = ReceiverText()
              try await receiver.prepare(code: code)
              let message = try await receiver.finish()

              expect {originalMessage}.to(equal(message))
          }
    }
  }
}
