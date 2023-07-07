import SwiftUI

struct ChatCircleAnimationView: View {

  // MARK: - Body

  var body: some View {
    ProgressView()
      .controlSize(.large)
      .tint(ColorTheme.purple.color)
      .scaleFadeAnimation()
  }
}

// MARK: - Preview

struct ChatCircleAnimationView_Previews: PreviewProvider {
  static var previews: some View {
    ChatCircleAnimationView()
  }
}
