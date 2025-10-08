import CoreSession

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
  func greetUser() async throws -> GreetUser {
    .init(title: .empty, description: .empty)
  }
  
  func fetchCompletions(prompt: String) async -> Chat? {
    let requestData = ChatRequest.fetchCompletions(prompt: prompt)
    do {
      let cats: Chat = try await requestManager.makeRequest(requestData)
      return cats
    } catch {
      print(error.localizedDescription)
      return nil
    }
  }
}
