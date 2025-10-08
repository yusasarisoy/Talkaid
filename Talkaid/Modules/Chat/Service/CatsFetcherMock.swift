struct ChatFetcherMock: ChatFetcher {
  func greetUser() async throws -> GreetUser {
    GreetUser(title: .empty, description: .empty)
  }
  
  func fetchCompletions(prompt: String) async -> Chat? {
    Chat.fetchMockData()
  }
}
