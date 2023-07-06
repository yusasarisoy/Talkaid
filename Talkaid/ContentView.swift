import SwiftUI

struct ContentView: View {
  var body: some View {
    ChatView(
      viewModel: ChatViewModel(),
      voiceInputRecognizer: VoiceInputRecognizer()
    )
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
