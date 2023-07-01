import SwiftUI

extension View {
  func frame(size: CGFloat) -> some View {
    frame(width: size, height: size)
  }
}
