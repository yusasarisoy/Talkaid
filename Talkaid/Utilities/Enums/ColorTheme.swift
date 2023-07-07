import SwiftUI

enum ColorTheme {
  case accentColor
  case aliceBlue
  case azure
  case blue
  case chatInputBackground
  case echoBlue
  case ghostWhite
  case mainBlue
  case micColor
  case purple
  case themeColor
  case vividBlue

  var color: Color {
    switch self {
    case .accentColor:
      return Color("AccentColor")
    case .aliceBlue:
      return Color("AliceBlue")
    case .azure:
      return Color("Azure")
    case .blue:
      return Color("Blue")
    case .chatInputBackground:
      return Color("ChatInputBackground")
    case .echoBlue:
      return Color("EchoBlue")
    case .ghostWhite:
      return Color("GhostWhite")
    case .mainBlue:
      return Color("MainBlue")
    case .micColor:
      return Color("MicColor")
    case .purple:
      return Color("Purple")
    case .themeColor:
      return Color("ThemeColor")
    case .vividBlue:
      return Color("VividBlue")
    }
  }
}
