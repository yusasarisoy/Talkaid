import SwiftUI

struct ChatView: View {

  // MARK: - Properties

  @State private var inputText: String = ""

  // MARK: - Body

  var body: some View {
    VStack(spacing: 16) {
      ChatHeaderView()
      ChatDateView()
      ChatListView(chatMessages: .constant([]))
      ChatInputView(inputText: $inputText)
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
