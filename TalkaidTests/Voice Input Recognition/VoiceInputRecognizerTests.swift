import XCTest
import Speech
@testable import Talkaid

final class VoiceInputRecognizerTests: XCTestCase {
  
  private let recognizer = MockSpeechRecognizer(isRecognizerAvailable: true)
  private var voiceInputRecognizer: VoiceInputRecognizer!
  
  override func setUp() {
    super.setUp()
    voiceInputRecognizer = VoiceInputRecognizer(recognizer: recognizer)
  }
  
  override func tearDown() {
    voiceInputRecognizer = nil
    super.tearDown()
  }
  
  func testStartTranscribing() async throws {
    // Given
    let expectation = XCTestExpectation(description: "Expect transcribing to be started")
    
    // When
    voiceInputRecognizer.transcribe()
    
    // Then
    try await Task.sleep(for: 1)
    XCTAssertNotNil(voiceInputRecognizer.request)
    expectation.fulfill()
  }
  
  func testStopTranscribing() async throws {
    // Given
    let expectation = XCTestExpectation(description: "Expect transcribing to be stopped")
    
    // When
    voiceInputRecognizer.stopTranscribing()
    
    // Then
    try await Task.sleep(for: 1)
    XCTAssertNil(voiceInputRecognizer.request)
    expectation.fulfill()
  }
}

final class MockSpeechRecognizer: SFSpeechRecognizer {
  
  let isRecognizerAvailable: Bool
  
  init?(isRecognizerAvailable: Bool) {
    self.isRecognizerAvailable = isRecognizerAvailable
    super.init(locale: Locale.current)
  }
  
  override var isAvailable: Bool {
    isRecognizerAvailable
  }
  
  override func recognitionTask(
    with request: SFSpeechRecognitionRequest,
    delegate: SFSpeechRecognitionTaskDelegate
  ) -> SFSpeechRecognitionTask {
    !isAvailable ? .init() : MockSpeechRecognitionTask()
  }
}

final class MockSpeechRecognitionTask: SFSpeechRecognitionTask { }
