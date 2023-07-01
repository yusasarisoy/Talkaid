import SwiftUI

struct ChatHeaderView: View {
  var body: some View {
    HStack {
      VStack {
        ImageTheme.chatAssistant.image
          .resizable()
          .frame(size: 40)
          .aspectRatio(contentMode: .fill)
          .clipped()
        Spacer()
      }
      VStack(alignment: .leading, spacing: 4) {
        Text("Good morning, Samantha")
          .font(.custom(FontTheme.sfProDisplay, size: 20).weight(.heavy))
          .foregroundColor(ColorTheme.accentColor.color)
        Text("How can I help you today?")
          .font(.custom(FontTheme.sfProText, size: 15))
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
