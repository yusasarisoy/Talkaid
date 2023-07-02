import SwiftUI

struct ChatView: View {

  // MARK: - Properties

  @State private var inputText: String = ""
  @ObservedObject private var viewModel = ChatViewModel()

  // MARK: - Body

  var body: some View {
    ZStack {
      VStack(spacing: 16) {
        ChatHeaderView()
        ChatDateView()
        ChatListView(chatMessages: $viewModel.chatMessages)
        ChatInputView(inputText: $inputText, didTapSendButton: {
            viewModel.sendMessage(inputText)
        })
      }
      .padding(.horizontal, 16)
      if viewModel.isLoading {
        progressView
      }
    }
  }
}

private extension ChatView {
  var progressView: some View {
    ProgressView("Loading...")
      .progressViewStyle(CircularProgressViewStyle(tint: ColorTheme.accentColor.color))
      .foregroundColor(ColorTheme.accentColor.color)
      .padding()
      .frame(maxWidth: .infinity)
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
