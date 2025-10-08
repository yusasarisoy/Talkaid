import SwiftUI

// MARK: - ChatBubble

struct ChatBubble: Identifiable, Equatable {
  let id = UUID()
  let content: String?
  let sender: Sender?

  enum Sender {
    case user
    case chatAssistant
  }
}

struct ChatBubbleView: View {

  // MARK: - Properties

  let message: ChatBubble

  private var sentByUser: Bool {
    message.sender == .user
  }

  // MARK: - Body

  var body: some View {
    HStack {
      if sentByUser {
        Spacer()
      }
      Text(message.content.orEmpty)
        .font(.body)
        .padding(16)
        .foregroundColor(sentByUser ? .white : .black)
        .background(sentByUser ? ColorTheme.azure.color : ColorTheme.aliceBlue.color)
        .cornerRadius(10, sentByUser: sentByUser)
      if !sentByUser {
        Spacer()
      }
    }
  }
}

struct ChatBubbleView_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 16) {
      ChatBubbleView(
        message: ChatBubble(
          content: "Hello, there!",
          sender: .user
        )
      )
      ChatBubbleView(
        message: ChatBubble(
          content: "Hello, how can I assist you?",
          sender: .chatAssistant
        )
      )
    }
  }
}
