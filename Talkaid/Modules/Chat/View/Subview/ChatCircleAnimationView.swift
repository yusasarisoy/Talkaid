import SwiftUI

struct ChatCircleAnimationView: View {

  // MARK: - Properties

  @Binding var animate: Bool

  // MARK: - Body

  var body: some View {
    Circle()
      .stroke(lineWidth: 5)
      .scale(animate ? 0.5 : 0)
      .opacity(animate ? 0 : 1)
      .animation(animate ? .easeIn(duration: 1.5) : .none, value: animate)
      .foregroundColor(ColorTheme.purple.color)
  }
}

// MARK: - Preview

struct ChatCircleAnimationView_Previews: PreviewProvider {
  static var previews: some View {
    ChatCircleAnimationView(animate: .constant(true))
      .frame(width: 100, height: 100)
  }
}
