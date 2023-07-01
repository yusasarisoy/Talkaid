import SwiftUI

struct ChatDateView: View {
  var body: some View {
    VStack {
      Text("Today")
        .font(.custom(FontTheme.sfProText, size: 13))
        .foregroundColor(ColorTheme.echoBlue.color)
    }
  }
}

struct ChatDateView_Previews: PreviewProvider {
  static var previews: some View {
    ChatDateView()
      .previewLayout(.sizeThatFits)
  }
}
