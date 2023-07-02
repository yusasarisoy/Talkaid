import SwiftUI

struct ChatListView: View {

  // MARK: - Properties

  @Binding var chatMessages: [ChatBubble]

  // MARK: - Body

  var body: some View {
    ScrollView {
      VStack(spacing: 16) {
        ForEach(chatMessages) { message in
          ChatBubbleView(message: message)
        }
      }
      .padding()
    }
  }
}

// MARK: - Preview

struct ChatListView_Previews: PreviewProvider {
  static var previews: some View {
    ChatListView(
      chatMessages: .constant(
        [
          ChatBubble(
            content: "Hello, there!",
            sender: .user
          ),
          ChatBubble(
            content: "Hello, how can I assist you?",
            sender: .chatAssistant
          )
        ]
      )
    )
  }
}
