import SwiftUI

enum ImageTheme {
  case chatAssistant

  var image: Image {
    switch self {
    case .chatAssistant:
      return Image(systemName: "person.wave.2")
    }
  }
}
