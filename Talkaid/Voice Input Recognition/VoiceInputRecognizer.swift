import Speech

final class VoiceInputRecognizer: ObservableObject {

  // MARK: - Properties

  @Published var transcript: String = .empty
  @Published var hasNotAuthorized: Bool = false
  @Published var averagePower: CGFloat = .zero {
    didSet {
      holderDecibel = averagePower
    }
  }
  private var timer: Timer?
  private var audioPlayer: AVAudioPlayer?
  private var audioEngine: AVAudioEngine?
  private var audioRecorder: AVAudioRecorder?
  private var task: SFSpeechRecognitionTask?
  private var recognizer: SFSpeechRecognizer?
  private var holderDecibel: CGFloat = .zero
  var request: SFSpeechAudioBufferRecognitionRequest?

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
    guard let recognizer, recognizer.isAvailable else {
      speak(VoiceInputRecognizerError.recognizerIsUnavailable.localizedDescription)
      return
    }

    do {
      let ((audioRecorder, audioEngine), request) = try prepareAudioEngine()
      self.audioRecorder = audioRecorder
      self.audioEngine = audioEngine
      self.request = request
      setUpAudioCapture()

      // Executes the speech recognition request and deliver the result.
      task = recognizer.recognitionTask(with: request) { [weak self] result, error in
        guard let self, let result else {
          let receivedFinalResult = (result?.isFinal).orFalse
          let receivedError = error != nil
          self?.averagePower = .zero
          guard !receivedFinalResult, !receivedError else { return }
          audioEngine.stop()
          audioEngine.inputNode.removeTap(onBus: .zero)
          return
        }

        // Get the average power in decibels.
        self.timer = .scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
          guard let self else { return }
          self.audioRecorder?.updateMeters()
          let averagePower = audioRecorder?.averagePower(forChannel: .zero) ?? .zero
          let difference = 160 + CGFloat(averagePower)
          self.averagePower = difference
        }

        self.speak(result.bestTranscription.formattedString)
      }
    } catch {
      resetVoiceInputRecognizer()
      speak(error.localizedDescription)
    }
  }

  func stopTranscribing() {
    resetVoiceInputRecognizer()
  }
}

// MARK: - Private Helper Methods

extension VoiceInputRecognizer {
  private func setUpAudioCapture() {
    let recordingSession = AVAudioSession.sharedInstance()

    do {
      try recordingSession.setCategory(.record)
      try recordingSession.setActive(true)
      try recordingSession.setMode(.measurement)

    } catch {
      speak(error.localizedDescription)
    }
  }

  private func captureAudio() -> AVAudioRecorder? {
    // This is the path where we plan to save the recording file.
    let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    guard let audioFilename = documentPath?.appendingPathComponent("record.caf") else { return .none }
    let settings: [String: Any] = [
      // kAudioFormatAppleIMA4 is a fast encoding scheme,
      // so it won't be too taxing for the limited iPhone processor,
      // and it supplies 4:1 compression,
      // so it won't take up too much storage space.
      AVFormatIDKey: kAudioFormatAppleIMA4 as AnyObject,
      // Current sample rate, 44.1 kHz, is the same as the standard for CD audio.
      // We could use 16 kHz.
      AVSampleRateKey: 44100,
      // iPhone has a one mic, so, unless the user use any additional hardware,
      // it would be enough.
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
    ]

    do {
      let audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
      audioRecorder.prepareToRecord()
      audioRecorder.isMeteringEnabled = true
      audioRecorder.record()
      self.audioRecorder = audioRecorder
    } catch {
      speak(error.localizedDescription)
    }

    return audioRecorder
  }

  private func resetVoiceInputRecognizer() {
    task?.cancel()
    audioEngine?.stop()
    audioEngine = .none
    request = .none
    task = .none
    timer?.invalidate()
  }

  private func prepareAudioEngine() throws -> (
    (audioRecorder: AVAudioRecorder?, audioEngine: AVAudioEngine),
    SFSpeechAudioBufferRecognitionRequest
  ) {
    let audioEngine = AVAudioEngine()

    let request = SFSpeechAudioBufferRecognitionRequest()
    let inputNode = audioEngine.inputNode

    // This gives us access to the audio data on the inputNode's output bus.
    // We request a buffer size of 1024 bytes, but the requested size isn’t guaranteed,
    // especially if we request a buffer that’s too small or large.
    // Apple’s documentation doesn’t specify what those limits are.
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

    return ((captureAudio(), audioEngine), request)
  }

  private func speak(_ message: String) {
    Task { @MainActor in
      transcript = message
    }
  }
}
