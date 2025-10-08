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
    configureAudioSession()
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
    
    Task {
      do {
        try await checkAnyErrorForSpeechRecognizer()
        configureAudioSession()
        let ((audioRecorder, audioEngine), request) = try prepareAudioEngine()
        self.audioRecorder = audioRecorder
        self.audioEngine = audioEngine
        self.request = request
        
        task = recognizer.recognitionTask(with: request) { [weak self] result, error in
          guard let self else { return }
          guard let result else {
            self.averagePower = .zero
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: .zero)
            return
          }
          
          self.timer = .scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
            guard let self else { return }
            self.audioRecorder?.updateMeters()
            let avg = self.audioRecorder?.averagePower(forChannel: .zero) ?? .zero
            self.averagePower = 160 + CGFloat(avg)
          }
          
          self.speak(result.bestTranscription.formattedString)
        }
      } catch {
        resetVoiceInputRecognizer()
        speak(error.localizedDescription)
      }
    }
  }

  func stopTranscribing() {
    resetVoiceInputRecognizer()
  }
}

// MARK: - Private Helper Methods

extension VoiceInputRecognizer {
  private func configureAudioSession() {
    do {
      let session = AVAudioSession.sharedInstance()
      try session.setCategory(.record, mode: .measurement, options: [.duckOthers])
      try? session.setPreferredSampleRate(44_100)
      try? session.setPreferredInputNumberOfChannels(1)
      try session.setActive(true, options: .notifyOthersOnDeactivation)
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
    task = nil
    
    audioRecorder?.stop()
    audioRecorder = nil
    
    if let engine = audioEngine {
      engine.inputNode.removeTap(onBus: .zero)
      engine.stop()
    }

    audioEngine = nil
    
    request?.endAudio()
    request = nil
    
    timer?.invalidate()
    timer = nil
    
    try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
  }

  private func prepareAudioEngine() throws -> (
    (audioRecorder: AVAudioRecorder?, audioEngine: AVAudioEngine),
    SFSpeechAudioBufferRecognitionRequest
  ) {
    let audioEngine = AVAudioEngine()
    let request = SFSpeechAudioBufferRecognitionRequest()
    request.shouldReportPartialResults = true
    
    let inputNode = audioEngine.inputNode
    inputNode.removeTap(onBus: 0)
    
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: nil) { buffer, _ in
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
