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
}
