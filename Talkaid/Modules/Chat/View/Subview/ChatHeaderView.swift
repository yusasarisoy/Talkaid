import SwiftUI

// MARK: - GreetUser

struct GreetUser: Equatable {
  let title: String?
  let description: String?
}

// MARK: - ChatHeaderView

struct ChatHeaderView: View {

  // MARK: - Properties

  let greetUser: GreetUser

  // MARK: - Body

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
        Text(greetUser.title.orEmpty)
          .font(.title3)
          .bold()
          .foregroundColor(ColorTheme.accentColor.color)
        Text(greetUser.description.orEmpty)
          .font(.subheadline)
          .foregroundColor(ColorTheme.echoBlue.color)
      }
    }
    .padding(.vertical, 4)
    .frame(height: 55)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

// MARK: - Preview

struct ChatHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    ChatHeaderView(
      greetUser: GreetUser(
        title: "Good morning, Samantha",
        description: "How can I help you today?"
      )
    )
    .previewLayout(.sizeThatFits)
  }
}
