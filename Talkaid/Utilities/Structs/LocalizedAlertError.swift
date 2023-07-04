import Foundation

struct LocalizedAlertError: LocalizedError {

  // MARK: - Properties

  let underlyingError: Error

  var errorDescription: String? {
    underlyingError.errorDescription
  }

  var recoverySuggestion: String? {
    underlyingError.recoverySuggestion
  }

  // MARK: - Initialization

  init?(error: Error?) {
    guard let error else { return nil }
    underlyingError = error
  }
}
