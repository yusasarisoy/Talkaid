// MARK: - FetchChatService

struct FetchChatService {

  // MARK: - Properties

  private let requestManager: RequestManagerProtocol

  // MARK: - Initialization

  init(requestManager: RequestManagerProtocol) {
    self.requestManager = requestManager
  }
}

// MARK: - ChatFetcher

extension FetchChatService: ChatFetcher {
  func fetchCompletions(prompt: String) async -> Chat? {
    let requestData = ChatRequest.fetchCompletions(prompt: prompt)
    do {
      let cats: Chat = try await requestManager.perform(requestData)
      return cats
    } catch {
      print(error.localizedDescription)
      return nil
    }
  }
}
