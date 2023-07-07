import SwiftUI

struct ChatInputView: View {

  // MARK: - Properties

  @State private var voiceInputRecordingTime = Date().addingTimeInterval(.zero)
  @Binding var inputText: String
  @Binding var showVoiceInput: Bool
  @Binding var shouldHideVoiceInput: Bool

  var sendMessage: () -> Void
  var sendVoiceInput: () -> Void

  // MARK: - View

  var body: some View {
    GeometryReader { geometry in
      VStack(spacing: .zero) {
        Spacer()
        VStack {
          HStack(spacing: 10) {
            inputTextField
            if !inputText.isEmpty {
              sendButton
            }
          }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 9)
        if showVoiceInput {
          voiceInputView
            .frame(height: geometry.size.height / 3)
        }
      }
    }
  }
}

private extension ChatInputView {
  var inputTextField: some View {
    TextField("✨ Ask me anything", text: $inputText)
      .onSubmit {
        sendMessage()
      }
      .font(.custom(FontTheme.sfProText, size: 17).weight(.bold))
      .autocorrectionDisabled(true)
      .foregroundColor(ColorTheme.micColor.color)
      .overlay(
        Image(systemName: IconTheme.mic)
          .font(.body.weight(.regular))
          .foregroundColor(ColorTheme.micColor.color)
          .opacity(!shouldHideVoiceInput && inputText.isEmpty ? 1 : 0)
          .onTapGesture {
            sendVoiceInput()
            voiceInputRecordingTime = Date().addingTimeInterval(.zero)
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
    Button(action: sendMessage) {
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
        Image(systemName: IconTheme.arrowUp)
          .foregroundColor(.white)
          .font(.body.weight(.bold))
      }
    }
  }

  var voiceInputView: some View {
    VStack {
      ZStack {
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 170, height: 170)
          .background(.black.opacity(0.1))
          .cornerRadius(170)
        Text("🎤 Tap to stop recording")
          .font(.custom(FontTheme.sfProText, size: 17))
          .foregroundColor(.white)
        VStack {
          HStack {
            Text(voiceInputRecordingTime, style: .timer)
              .font(.custom(FontTheme.sfProText, size: 17))
              .foregroundColor(.white)
              .padding([.leading, .top], 16)
            Spacer()
          }
          Spacer()
        }
      }
    }
    .background(ColorTheme.mainBlue.color)
    .onTapGesture {
      sendVoiceInput()
    }
  }
}

// MARK: - Preview
struct ChatInputView_Previews: PreviewProvider {
  static var previews: some View {
    ChatInputView(
      inputText: .constant(.empty),
      showVoiceInput: .constant(true),
      shouldHideVoiceInput: .constant(false),
      sendMessage: { },
      sendVoiceInput: { }
    )
      .previewLayout(.sizeThatFits)
  }
}
