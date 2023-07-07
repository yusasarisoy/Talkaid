import Speech

final class VoiceInputRecognizer: ObservableObject {

  // MARK: - Properties

  @Published var transcript: String = .empty
  @Published var hasNotAuthorized: Bool = false

  private var audioEngine: AVAudioEngine?
  var request: SFSpeechAudioBufferRecognitionRequest?
  private var task: SFSpeechRecognitionTask?
  private var recognizer: SFSpeechRecognizer?

  // MARK: - Initialization

  init(recognizer: SFSpeechRecognizer? = SFSpeechRecognizer()) {
    self.recognizer = recognizer
  }

  // MARK: - Deinitialization

  deinit {
    resetVoiceInputRecognizer()
  }
}

// MARK: - Internal Helper Methods

extension VoiceInputRecognizer {
  func checkAnyErrorForSpeechRecognizer() async throws {
    do {
      guard recognizer != .none else {
        throw VoiceInputRecognizerError.couldNotInitializeRecognizer
      }

      guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
        throw VoiceInputRecognizerError.recognizerCouldNotBeAuthorized
      }

      guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
        throw VoiceInputRecognizerError.noPermissionForRecord
      }
    } catch {
      Task { @MainActor in
        hasNotAuthorized = true
        speak(error.localizedDescription)
      }
    }
  }

  func transcribe() {
    Task(priority: .background) { [weak self] in
      guard
        let self,
        let recognizer,
        recognizer.isAvailable
      else {
        self?.speak(VoiceInputRecognizerError.recognizerIsUnavailable.localizedDescription)
        return
      }

      do {
        let (audioEngine, request) = try prepareAudioEngine()
        self.audioEngine = audioEngine
        self.request = request

        self.task = recognizer.recognitionTask(with: request) { result, error in
          guard let result else {
            let receivedFinalResult = (result?.isFinal).orFalse
            let receivedError = error != nil

            guard !receivedFinalResult, !receivedError else { return }
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: .zero)
            return
          }

          self.speak(result.bestTranscription.formattedString)
        }
      } catch {
        self.resetVoiceInputRecognizer()
        self.speak(error.localizedDescription)
      }
    }
  }

  func stopTranscribing() {
    resetVoiceInputRecognizer()
  }
}

// MARK: - Private Helper Methods

extension VoiceInputRecognizer {
  private func resetVoiceInputRecognizer() {
    task?.cancel()
    audioEngine?.stop()
    audioEngine = .none
    request = .none
    task = .none
  }

  private func prepareAudioEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
    let audioEngine = AVAudioEngine()

    let request = SFSpeechAudioBufferRecognitionRequest()
    request.shouldReportPartialResults = true

    let audioSession = AVAudioSession.sharedInstance()
    try audioSession.setCategory(.record, mode: .measurement)
    try audioSession.setActive(true)
    let inputNode = audioEngine.inputNode

    let recordingFormat = inputNode.outputFormat(forBus: .zero)
    inputNode.installTap(
      onBus: .zero,
      bufferSize: 1024,
      format: recordingFormat
    ) { buffer, _ in
      request.append(buffer)
    }

    audioEngine.prepare()
    try audioEngine.start()

    return (audioEngine, request)
  }

  private func speak(_ message: String) {
    Task { @MainActor in
      transcript = message
    }
  }
}
