import SwiftUI

struct ChatHeaderView: View {
  var body: some View {
    HStack {
      VStack {
        ImageTheme.chatAssistant.image
          .resizable()
          .frame(width: 40, height: 40)
          .aspectRatio(contentMode: .fill)
          .clipped()
        Spacer()
      }
      VStack(alignment: .leading, spacing: 4) {
        Text("Good morning, Samantha")
          .font(FontTheme.sfProDisplayBold20.font)
          .foregroundColor(ColorTheme.pianoBlack.color)
        Text("How can I help you today?")
          .font(FontTheme.sfProText15.font)
          .foregroundColor(ColorTheme.echoBlue.color)
      }
    }
    .padding(.vertical, 4)
    .frame(height: 55)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

struct ChatHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    ChatHeaderView()
      .previewLayout(.sizeThatFits)
  }
}
