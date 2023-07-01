import SwiftUI

struct ChatInputView: View {

  // MARK: - Properties

  @Binding var inputText: String

  // MARK: - View
  var body: some View {
    HStack(spacing: 10) {
      inputTextField
      if !inputText.isEmpty {
        sendButton
      }
    }
  }
}

private extension ChatInputView {
  var inputTextField: some View {
    TextField("✨ Ask me anything", text: $inputText)
      .font(.custom(FontTheme.sfProText, size: 17).weight(.bold))
      .autocorrectionDisabled(true)
      .foregroundColor(ColorTheme.micColor.color)
      .overlay(
        Image(systemName: "mic")
          .font(.body.weight(.regular))
          .foregroundColor(ColorTheme.micColor.color)
          .opacity(inputText.isEmpty ? 1 : 0)
          .onTapGesture {
            inputText = ""
            // TODO: - Show voice input view and manage the voice input.
          },
        alignment: .trailing
      )
      .font(.headline)
      .padding(.vertical, 9)
      .padding(.horizontal, 16)
      .background(
        Capsule()
          .fill(ColorTheme.chatInputBackground.color)
      )
  }

  var sendButton: some View {
    ZStack {
      Rectangle()
        .foregroundColor(.clear)
        .frame(width: 40, height: 40)
        .background(
          LinearGradient(
            stops: [
              Gradient.Stop(color: ColorTheme.vividBlue.color, location: 0),
              Gradient.Stop(color: ColorTheme.blue.color, location: 0.5),
              Gradient.Stop(color: ColorTheme.purple.color, location: 1)
            ],
            startPoint: UnitPoint(x: 0.43, y: -0.53),
            endPoint: UnitPoint(x: 0.78, y: 1.44)
          )
        )
        .cornerRadius(100)
      Image(systemName: "arrow.up")
        .foregroundColor(.white)
        .font(.body.weight(.bold))
    }
  }
}

// MARK: - Preview
struct ChatInputView_Previews: PreviewProvider {
  static var previews: some View {
    ChatInputView(inputText: .constant(""))
      .previewLayout(.sizeThatFits)
  }
}
