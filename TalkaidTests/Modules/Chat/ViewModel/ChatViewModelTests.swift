import XCTest
@testable import Talkaid

@MainActor
final class ChatViewModelTests: XCTestCase {

  // MARK: - Properties

  private var sut: ChatViewModel!

  // MARK: - Override Methods

  override func setUp() {
    super.setUp()
    sut = ChatViewModel()
  }

  override func tearDown() {
    sut = nil
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
    XCTAssertEqual(sut.chatMessages.count, 0)
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
}
