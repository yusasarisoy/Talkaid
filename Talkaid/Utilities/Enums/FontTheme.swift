import SwiftUI

enum FontTheme {
  private enum Fonts {
    static let sfProDisplayBold = "SF-Pro-Display-Bold"
    static let sfProText = "SF-Pro-Text"
  }
  
  case sfProDisplayBold20
  case sfProText15
  case sfProText13

  var font: Font {
    switch self {
    case .sfProDisplayBold20:
      return Font.custom(Fonts.sfProDisplayBold, size: 20)
    case .sfProText15:
      return Font.custom(Fonts.sfProText, size: 15)
    case .sfProText13:
      return Font.custom(Fonts.sfProText, size: 13)
    }
  }
}
