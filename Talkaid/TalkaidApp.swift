import CoreSession
import SwiftUI

@main
struct TalkaidApp: App {

  // MARK: - Initialization

  init() {
    configureCoreSession()
  }

  // MARK: - UI

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

// MARK: - Private Helper Functions

extension TalkaidApp {
  private func configureCoreSession() {
    enum APIConstant {
      static let scheme: String = "https"
      static let host = "api.openai.com"
      static let apiKey = "YOUR_API_KEY"
    }

    CoreSessionManager.shared.configure(
      scheme: APIConstant.scheme,
      host: APIConstant.host,
      apiKey: APIConstant.apiKey
    )
  }
}
