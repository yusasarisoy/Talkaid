import SwiftUI

enum ImageTheme {
  case chatAssistant

  var image: Image {
    switch self {
    case .chatAssistant:
      return Image("ChatAssistant")
    }
  }
}
