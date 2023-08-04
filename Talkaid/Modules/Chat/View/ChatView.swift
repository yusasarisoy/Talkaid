import SwiftUI

struct ChatView: View {

  // MARK: - Properties

  @ObservedObject var viewModel: ChatViewModel
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
      VStack(spacing: 16) {
        VStack(spacing: 16) {
          ChatHeaderView(greetUser: viewModel.greetUser)
          ChatDateView()
        }
        .opacity((viewModel.greetUser.title?.isEmpty).orFalse ? 0 : 1)
        ChatListView(chatMessages: $viewModel.chatMessages)
      }
      .padding(.horizontal, 16)
      ChatInputView(
        inputText: $viewModel.inputText,
        showVoiceInput: $viewModel.showVoiceInput,
        shouldHideVoiceInput: $voiceInputRecognizer.hasNotAuthorized,
        averagePower: $voiceInputRecognizer.averagePower,
        sendMessage: sendMessage,
        sendVoiceInput: sendVoiceInput
      )
      .ignoresSafeArea(.all, edges: [.horizontal])
      .opacity(viewModel.isLoading ? 0 : 1)
      if viewModel.isLoading {
        ChatCircleAnimationView()
      }
    }
    .task {
      do {
        try await viewModel.greetTheUser()
        try await voiceInputRecognizer.checkAnyErrorForSpeechRecognizer()
      } catch {
        viewModel.errorType = .unableToConnectToChatAssistant
      }
    }
    .showAlert(error: $viewModel.errorType)
  }
}

// MARK: - Private Helper Methods

extension ChatView {
  private func sendMessage() {
    Task {
      try await viewModel.sendMessage(.init(content: viewModel.inputText, sender: .user))
    }
  }

  private func sendVoiceInput() {
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
}

// MARK: - Preview

struct ChatView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ChatView(
        viewModel: ChatViewModel(
          chatFetcher: ChatFetcherMock()
        ),
        voiceInputRecognizer: VoiceInputRecognizer()
      )
      ChatView(
        viewModel: ChatViewModel(
          chatFetcher: ChatFetcherMock()
        ),
        voiceInputRecognizer: VoiceInputRecognizer()
      )
      .preferredColorScheme(.dark)
    }
  }
}

import Foundation

// MARK: - Mock data

extension Chat {
  static let mock = loadChat()
}

private struct ChatMock: Decodable {
  let chat: Chat
}

private func loadChat() -> Chat? {
  guard
    let url = Bundle.main.url(forResource: "ChatMock", withExtension: "json"),
    let data = try? Data(contentsOf: url)
  else {
    return nil
  }

  let decoder = JSONDecoder()
  decoder.keyDecodingStrategy = .convertFromSnakeCase
  let jsonMock = try? decoder.decode(ChatMock.self, from: data)
  return jsonMock?.chat
}
