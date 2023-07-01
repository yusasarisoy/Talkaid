import SwiftUI

enum ColorTheme {
  case ghostWhite
  case pianoBlack
  case echoBlue

  var color: Color {
    switch self {
    case .ghostWhite:
      return Color("GhostWhite")
    case .pianoBlack:
      return Color("PianoBlack")
    case .echoBlue:
      return Color("EchoBlue")
    }
  }
}
