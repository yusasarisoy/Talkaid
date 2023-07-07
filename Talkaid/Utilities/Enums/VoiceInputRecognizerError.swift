import Foundation

enum VoiceInputRecognizerError: LocalizedError {
  case couldNotInitializeRecognizer
  case recognizerCouldNotBeAuthorized
  case noPermissionForRecord
  case recognizerIsUnavailable

  var errorDescription: String? {
    switch self {
    case .couldNotInitializeRecognizer:
      return "The voice input recognizer could not initialize for now."
    case .recognizerCouldNotBeAuthorized:
      return "The voice input recognizer could not be authorized by you."
    case .noPermissionForRecord:
      return "We could not get permission for the audio record by you."
    case .recognizerIsUnavailable:
      return "The voice input recognizer is not available for now."
    }
  }
}
