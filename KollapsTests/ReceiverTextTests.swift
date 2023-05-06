//
//  ReceiverTextTests.swift
//  KollapsTests
//
//  Created by Rasmus Thomsen on 06.05.23.
//

import Quick
import Nimble
@testable import Kollaps

class ReceiverTextTests: QuickSpec {
  override func spec() {
      describe("The 'ReceiverText'") {
          var receiver: ReceiverText!
          beforeEach {
              receiver = ReceiverText()
          }

          it("correctly sends and receives a text") {
              let originalMessage = "test"
              let sender = SenderText()
              let code = try await sender.prepare(con: originalMessage)
              try await receiver.prepare(code: code)
              expect {receiver.fileName}.to(beEmpty())
              expect {receiver.fileSize}.to(equal(4))
              let message = try await receiver.finish()

              expect {originalMessage}.to(equal(message))
          }
    }
  }
}
