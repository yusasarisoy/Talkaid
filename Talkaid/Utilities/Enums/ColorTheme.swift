import SwiftUI

enum ColorTheme {
  case ghostWhite
  case accentColor
  case echoBlue
  case micColor
  case chatInputBackground
  case vividBlue
  case blue
  case purple

  var color: Color {
    switch self {
    case .ghostWhite:
      return Color("GhostWhite")
    case .accentColor:
      return Color("AccentColor")
    case .echoBlue:
      return Color("EchoBlue")
    case .micColor:
      return Color("MicColor")
    case .chatInputBackground:
      return Color("ChatInputBackground")
    case .vividBlue:
      return Color("VividBlue")
    case .blue:
      return Color("Blue")
    case .purple:
      return Color("Purple")
    }
  }
}
