//
//  ChatFetcherMock.swift
//  TalkaidTests
//
//  Created by Yuşa on 8.10.2025.
//

import XCTest
@testable import Talkaid

final class ChatFetcherMock: ChatFetcher {
  
  // MARK: - Properties
  
  var fetchCompletionsReturnValue: Chat?
  var greetUserReturnValue: GreetUser!
  var greetUserError: Error?
  private(set) var greetUserCalled = false
  
  // MARK: - Helper Functions
  
  func fetchCompletions(prompt: String) async -> Chat? {
    fetchCompletionsReturnValue
  }
  
  func greetUser() async throws -> GreetUser {
    greetUserCalled = true
    if let e = greetUserError { throw e }
    return greetUserReturnValue
  }
}
