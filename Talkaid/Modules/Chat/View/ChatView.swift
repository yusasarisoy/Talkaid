import SwiftUI

struct ChatView: View {

  // MARK: - Properties

  @ObservedObject private var viewModel = ChatViewModel()
  @ObservedObject private var voiceInputRecognizer = VoiceInputRecognizer()

  // MARK: - Body

  var body: some View {
    ZStack {
      VStack(spacing: 16) {
        ChatHeaderView()
        ChatDateView()
        ChatListView(chatMessages: $viewModel.chatMessages)
      }
      .padding(.horizontal, 16)
      ChatInputView(
        inputText: $viewModel.inputText,
        showVoiceInput: $viewModel.showVoiceInput,
        sendMessage: {
          viewModel.sendMessage(.init(content: viewModel.inputText, sender: .user))
        }
      ) {
        if !viewModel.showVoiceInput {
          voiceInputRecognizer.transcribe()
        } else {
          voiceInputRecognizer.stopTranscribing()
          viewModel.sendMessage(.init(content: voiceInputRecognizer.transcript, sender: .user))
        }
        viewModel.showVoiceInput.toggle()
      }
      if viewModel.isLoading {
        progressView
      }
    }
    .showAlert(error: $viewModel.errorType)
  }
}

// MARK: - Progress View

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
