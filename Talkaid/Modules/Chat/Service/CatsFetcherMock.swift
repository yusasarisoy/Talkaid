struct ChatFetcherMock: ChatFetcher {
  func fetchCompletions(prompt: String) async -> Chat? {
    Chat.mock
  }
}
