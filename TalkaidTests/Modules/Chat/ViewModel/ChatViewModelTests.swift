import XCTest
@testable import Talkaid

@MainActor
final class ChatViewModelTests: XCTestCase {

  // MARK: - Properties

  private var sut: ChatViewModel!
  private var chatAPIManager: MockChatAPIManager!

  // MARK: - Override Methods

  override func setUp() {
    super.setUp()
    chatAPIManager = MockChatAPIManager()
    sut = ChatViewModel(chatAPIManager: chatAPIManager)
  }

  override func tearDown() {
    sut = nil
    chatAPIManager = nil
    super.tearDown()
  }

  // MARK: - Tests

  func testSendMessage() async {
    // Given
    let inputText = "Hello"
    let userMessage = ChatBubble(content: inputText, sender: .user)

    // When
    sut.sendMessage(userMessage)

    // Then
    XCTAssertEqual(sut.chatMessages.count, 1)
    XCTAssertEqual(sut.chatMessages.first, userMessage)
    XCTAssertEqual(sut.inputText, .empty)
  }

  func testSendEmptyMessage() async {
    // Given
    let inputText: String = .empty
    let userMessage = ChatBubble(content: inputText, sender: .user)

    // When
    sut.inputText = inputText
    sut.sendMessage(userMessage)

    // Then
    XCTAssertEqual(sut.chatMessages.count, .zero)
    XCTAssertEqual(sut.inputText, .empty)
  }

  func testReceiveBotMessage() async {
    // Given
    let inputText = "Hello"
    let chatAssistantMessage = ChatBubble(content: inputText, sender: .chatAssistant)

    // When
    sut.inputText = inputText
    sut.sendMessage(chatAssistantMessage)

    // Then
    XCTAssertEqual(sut.chatMessages.last, chatAssistantMessage)
    XCTAssertEqual(sut.inputText, .empty)
  }

  func testGreetTheUser() async throws {
    // Given
    let expectedGreetUser = GreetUser(
      title: "Good morning, Samantha",
      description: "How can I help you today?"
    )

    // When
    try await sut.greetTheUser()
    chatAPIManager.greetUserReturnValue = expectedGreetUser

    // Then
    XCTAssertEqual(sut.greetUser, expectedGreetUser)
    XCTAssertFalse(sut.isLoading)
  }

  func testSendMessageWithValidMessage() {
    // Given
    let message = ChatBubble(content: "Hello", sender: .user)

    // When
    sut.sendMessage(message)

    // Then
    XCTAssertEqual(sut.inputText, .empty)
    XCTAssertFalse(sut.isLoading)
    XCTAssertEqual(sut.chatMessages.count, 1)
    XCTAssertEqual(sut.chatMessages.first, message)
    XCTAssertNil(sut.errorType)
  }

  func testSendMessageWithInvalidMessage() {
    // Given
    let message = ChatBubble(content: .empty, sender: .user)

    // When
    sut.sendMessage(message)

    // Then
    XCTAssertEqual(sut.inputText, .empty)
    XCTAssertFalse(sut.isLoading)
    XCTAssertEqual(sut.chatMessages.count, .zero)
    XCTAssertEqual(sut.errorType, .emptyMessage)
  }
}
