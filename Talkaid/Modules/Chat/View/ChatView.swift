import SwiftUI

struct ChatView: View {

  // MARK: - Properties

  @ObservedObject private var viewModel = ChatViewModel()
  @ObservedObject private var voiceInputRecognizer = VoiceInputRecognizer()

  // MARK: - Initialization

  init(
    viewModel: ChatViewModel,
    voiceInputRecognizer: VoiceInputRecognizer
  ) {
    self.viewModel = viewModel
    self.voiceInputRecognizer = voiceInputRecognizer
  }

  // MARK: - Body

  var body: some View {
    ZStack {
      if viewModel.isLoading {
        ChatCircleAnimationView()
      } else {
        VStack(spacing: 16) {
          ChatHeaderView(greetUser: viewModel.greetUser)
            .opacity((viewModel.greetUser.title?.isEmpty).orFalse ? 0 : 1)
          ChatDateView()
          ChatListView(chatMessages: $viewModel.chatMessages)
        }
        .padding(.horizontal, 16)
        ChatInputView(
          inputText: $viewModel.inputText,
          showVoiceInput: $viewModel.showVoiceInput,
          sendMessage: {
            Task {
              try await viewModel.sendMessage(.init(content: viewModel.inputText, sender: .user))
            }
          },
          sendVoiceInput: {
            if !viewModel.showVoiceInput {
              voiceInputRecognizer.transcribe()
            } else {
              voiceInputRecognizer.stopTranscribing()
              Task {
                try await viewModel.sendMessage(.init(content: voiceInputRecognizer.transcript, sender: .user))
              }
            }
            viewModel.showVoiceInput.toggle()
          }
        )
      }
    }
    .task {
      do {
        try await viewModel.greetTheUser()
      } catch {
        viewModel.errorType = .unableToConnectToChatAssistant
      }
    }
    .showAlert(error: $viewModel.errorType)
  }
}

// MARK: - Preview

struct ChatView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ChatView(
        viewModel: ChatViewModel(),
        voiceInputRecognizer: VoiceInputRecognizer()
      )
      ChatView(
        viewModel: ChatViewModel(),
        voiceInputRecognizer: VoiceInputRecognizer()
      )
      .preferredColorScheme(.dark)
    }
  }
}
