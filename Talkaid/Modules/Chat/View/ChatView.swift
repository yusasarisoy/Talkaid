import SwiftUI

struct ChatView: View {
  var body: some View {
    VStack(spacing: 16) {
      ChatHeaderView()
    }
    .padding(.horizontal, 16)
    .background(ColorTheme.ghostWhite.color)
  }
}

struct ChatView_Previews: PreviewProvider {
  static var previews: some View {
    ChatView()
  }
}
