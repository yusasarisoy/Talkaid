import SwiftUI

struct ChatView: View {

  // MARK: - Properties

  @State private var inputText: String = ""
  @ObservedObject private var viewModel = ChatViewModel()

  // MARK: - Body

  var body: some View {
    VStack(spacing: 16) {
      ChatHeaderView()
      ChatDateView()
      ChatListView(chatMessages: $viewModel.chatMessages)
      ChatInputView(inputText: $inputText, didTapSendButton: {
        viewModel.sendMessage(inputText)
      })
    }
    .padding(.horizontal, 16)
  }
}

// MARK: - Preview

struct ChatView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ChatView()
      ChatView()
        .preferredColorScheme(.dark)
    }
  }
}
