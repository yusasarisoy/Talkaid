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
    await sut.sendMessage(userMessage)

    // Then
    XCTAssertEqual(sut.chatMessages.count, 2)
    XCTAssertEqual(sut.chatMessages.first, userMessage)
    XCTAssertEqual(sut.inputText, "")
  }

  func testSendEmptyMessage() async {
    // Given
    let inputText = ""
    let userMessage = ChatBubble(content: inputText, sender: .user)

    // When
    sut.inputText = inputText
    await sut.sendMessage(userMessage)

    // Then
    XCTAssertEqual(sut.chatMessages.count, 0)
    XCTAssertEqual(sut.inputText, "")
  }

  func testReceiveBotMessage() async {
    // Given
    let inputText = "Hello"
    let chatAssistantMessage = ChatBubble(content: inputText, sender: .chatAssistant)

    // When
    sut.inputText = inputText
    await sut.sendMessage(chatAssistantMessage)

    // Then
    XCTAssertEqual(sut.chatMessages.last, chatAssistantMessage)
    XCTAssertEqual(sut.inputText, "")
  }
}
