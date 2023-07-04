import Foundation

enum Error: LocalizedError {

  // MARK: - Cases

  case emptyMessage
  case unableToConnectToChatAssistant

  var errorDescription: String? {
    switch self {
    case .emptyMessage:
      return "Empty message"
    case .unableToConnectToChatAssistant:
      return "Unable to connect to chat assistant"
    }
  }

  var recoverySuggestion: String? {
    switch self {
    case .emptyMessage:
      return "Sending message failed due to missing message"
    case .unableToConnectToChatAssistant:
      return "We are currently experiencing connection issues with our chat assistant. Please try again later."
    }
  }
}
