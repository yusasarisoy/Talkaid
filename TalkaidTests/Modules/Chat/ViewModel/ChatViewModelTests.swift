import XCTest
@testable import Talkaid

@MainActor
final class ChatViewModelTests: XCTestCase {

  // MARK: - Properties

  private var sut: ChatViewModel!
  private var chatFetcher: ChatFetcherMock!

  // MARK: - Override Methods

  override func setUp() {
    super.setUp()
    chatFetcher = ChatFetcherMock()
    sut = ChatViewModel(chatFetcher: chatFetcher)
  }

  override func tearDown() {
    sut = nil
    chatFetcher = nil
    super.tearDown()
  }

  // MARK: - Tests

  func testSendMessage() async throws {
    // Given
    let inputText = "Hello"
    let userMessage = ChatBubble(content: inputText, sender: .user)

    // When
    try await sut.sendMessage(userMessage)
    try await Task.sleep(for: 2)

    // Then
    XCTAssertEqual(sut.chatMessages.count, 2)
    XCTAssertEqual(sut.chatMessages.first, userMessage)
    XCTAssertEqual(sut.inputText, .empty)
  }

  func testSendEmptyMessage() async throws {
    // Given
    let inputText: String = .empty
    let userMessage = ChatBubble(content: inputText, sender: .user)

    // When
    sut.inputText = inputText
    try await sut.sendMessage(userMessage)
    try await Task.sleep(for: 2)

    // Then
    XCTAssertEqual(sut.chatMessages.count, .zero)
    XCTAssertEqual(sut.inputText, .empty)
  }

  func testReceiveBotMessage() async throws {
    // Given
    let inputText = "Hello"
    let chatAssistantMessage = ChatBubble(content: inputText, sender: .chatAssistant)

    // When
    sut.inputText = inputText
    try await sut.sendMessage(chatAssistantMessage)
    try await Task.sleep(for: 2)

    // Then
    XCTAssertEqual(sut.chatMessages.last, chatAssistantMessage)
    XCTAssertEqual(sut.inputText, .empty)
  }
  
  func testGreetTheUser() async throws {
    let expected = GreetUser(
      title: "Good morning, Samantha",
      description: "How can I help you today?"
    )
    chatFetcher.greetUserReturnValue = expected
    
    await sut.greetTheUser()
    
    XCTAssertEqual(sut.greetUser, expected)
    XCTAssertFalse(sut.isLoading)
    XCTAssertTrue(chatFetcher.greetUserCalled)
  }

  func testSendMessageWithValidMessage() async throws {
    // Given
    let message = ChatBubble(content: "Hello", sender: .user)

    // When
    try await sut.sendMessage(message)
    try await Task.sleep(for: 2)

    // Then
    XCTAssertEqual(sut.inputText, .empty)
    XCTAssertFalse(sut.isLoading)
    XCTAssertEqual(sut.chatMessages.count, 2)
    XCTAssertEqual(sut.chatMessages.first, message)
    XCTAssertNil(sut.errorType)
  }

  func testSendMessageWithInvalidMessage() async throws {
    // Given
    let message = ChatBubble(content: .empty, sender: .user)

    // When
    try await sut.sendMessage(message)

    // Then
    XCTAssertEqual(sut.inputText, .empty)
    XCTAssertFalse(sut.isLoading)
    XCTAssertEqual(sut.chatMessages.count, .zero)
    XCTAssertEqual(sut.errorType, .emptyMessage)
  }
}
