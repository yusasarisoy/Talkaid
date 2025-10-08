import Combine

// MARK: - ChatFetcher

protocol ChatFetcher {
  func fetchCompletions(prompt: String) async -> Chat?
  func greetUser() async throws -> GreetUser
}

@MainActor
final class ChatViewModel: ObservableObject {

  // MARK: - Properties

  @Published var inputText: String = .empty
  @Published var showVoiceInput: Bool = false
  @Published var isLoading = true
  @Published var chatMessages: [ChatBubble] = []
  @Published var errorType: Error?
  @Published var greetUser = GreetUser(title: .empty, description: .empty)

  private let chatFetcher: ChatFetcher

  // MARK: - Initialization

  init(chatFetcher: ChatFetcher) {
    self.chatFetcher = chatFetcher
  }
}

// MARK: - Helper Methods

extension ChatViewModel {
  func greetTheUser() async {
    isLoading = true
    defer { isLoading = false }
    do {
      greetUser = try await chatFetcher.greetUser()
    } catch {
      greetUser = GreetUser(title: "Hello!", description: nil)
    }
  }
  
  func sendMessage(_ message: ChatBubble) async throws {
    inputText = .empty
    guard message.content.isTextContainsCharacter else {
      errorType = .emptyMessage
      isLoading = false
      return
    }
    isLoading = true
    chatMessages.append(message)
    guard message.sender == .user else { return }
    let chatAssistantMessage = await chatFetcher.fetchCompletions(prompt: message.content.orEmpty)
    chatMessages.append(
      .init(
        content: chatAssistantMessage?.choices?.first?.message?.content.orEmpty,
        sender: .chatAssistant
      )
    )
    isLoading = false
  }
}
