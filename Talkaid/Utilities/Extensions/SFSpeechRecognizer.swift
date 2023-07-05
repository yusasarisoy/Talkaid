import Speech

extension SFSpeechRecognizer {
  static func hasAuthorizationToRecognize() async -> Bool {
    await withCheckedContinuation { continuation in
      requestAuthorization { authorization in
        continuation.resume(returning: authorization == .authorized)
      }
    }
  }
}
