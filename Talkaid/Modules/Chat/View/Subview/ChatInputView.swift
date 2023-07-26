import SwiftUI

struct ChatInputView: View {

  // MARK: - Properties

  @FocusState private var inputFieldIsFocused: Bool
  @State private var voiceInputRecordingTime = Date().addingTimeInterval(.zero)
  @Binding var inputText: String
  @Binding var showVoiceInput: Bool
  @Binding var shouldHideVoiceInput: Bool
  @Binding var averagePower: CGFloat

  private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

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
          .padding(.horizontal, 16)
          .padding(.vertical, 9)
          .background(
            Rectangle()
              .fill(ColorTheme.themeColor.color)
              .shadow(
                color: ColorTheme.accentColor.color.opacity(0.08),
                radius: 4,
                x: .zero,
                y: -8
              )
          )
        }
        if showVoiceInput {
          voiceInputView
            .frame(height: geometry.size.height / 3)
        }
      }
    }
  }
}

// MARK: - Components

private extension ChatInputView {
  var inputTextField: some View {
    TextField("✨ Ask me anything", text: $inputText)
      .onTapGesture {
        timer.upstream.connect().cancel()
        showVoiceInput = false
        voiceInputRecordingTime = Date().addingTimeInterval(.zero)
      }
      .onSubmit {
        sendTheMessage()
      }
      .focused($inputFieldIsFocused)
      .font(.custom(FontTheme.sfProText, size: 17).weight(.bold))
      .autocorrectionDisabled(true)
      .foregroundColor(ColorTheme.micColor.color)
      .overlay(
        Image(systemName: IconTheme.mic)
          .font(.body.weight(.regular))
          .foregroundColor(ColorTheme.micColor.color)
          .opacity(!shouldHideVoiceInput && inputText.isEmpty ? 1 : 0)
          .onTapGesture {
            inputFieldIsFocused = false
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
    Button(action: sendTheMessage) {
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
    GeometryReader { geometry in
      VStack {
        ZStack {
          Rectangle()
            .foregroundColor(.clear)
            .background(.black.opacity(0.1))
            .frame(size: min(geometry.size.height, max(0, averagePowerLimit) + 147))
            .cornerRadius(min(geometry.size.height, max(0, averagePowerLimit) + 147))
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
        timer.upstream.connect().cancel()
        sendVoiceInput()
      }
      .onReceive(timer) { _ in
        averagePower -= 10
      }
    }
  }
}

extension ChatInputView {
  private var averagePowerLimit: CGFloat {
    guard averagePower > 0 else { return 0 }
    guard averagePower < 50 else { return 50 }
    return averagePower
  }

  private func sendTheMessage() {
    inputFieldIsFocused = false
    sendMessage()
  }
}

// MARK: - Preview

struct ChatInputView_Previews: PreviewProvider {
  static var previews: some View {
    ChatInputView(
      inputText: .constant(.empty),
      showVoiceInput: .constant(true),
      shouldHideVoiceInput: .constant(false),
      averagePower: .constant(170),
      sendMessage: { },
      sendVoiceInput: { }
    )
    .previewLayout(.sizeThatFits)
  }
}
