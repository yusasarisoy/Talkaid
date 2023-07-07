import SwiftUI

extension View {
  func frame(size: CGFloat) -> some View {
    frame(width: size, height: size)
  }

  func cornerRadius(_ radius: CGFloat, sentByUser: Bool) -> some View {
    let corners: UIRectCorner = sentByUser
    ? [.bottomLeft, .topLeft, .topRight]
    : [.bottomRight, .topLeft, .topRight]
    return clipShape(RoundedCorner(radius: radius, corners: corners))
  }

  func showAlert(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
    let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
    return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
      Button(buttonTitle) {
        error.wrappedValue = nil
      }
    } message: { error in
      Text(error.recoverySuggestion.orEmpty)
    }
  }

  func scaleFadeAnimation() -> some View {
    modifier(ScaleFadeAnimationModifier())
  }
}
