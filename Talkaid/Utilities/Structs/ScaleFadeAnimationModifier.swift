import SwiftUI

struct ScaleFadeAnimationModifier: ViewModifier {

  // MARK: - Properties

  @State private var animate = false

  // MARK: - Body

  func body(content: Content) -> some View {
    content
      .scaleEffect(animate ? 1.2 : 1)
      .opacity(animate ? 0.2 : 1)
      .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animate)
  }
}
