// MARK: - ChatRequest

enum ChatRequest {
  case fetchCompletions(prompt: String)
}

// MARK: - RequestProtocol

extension ChatRequest: RequestProtocol {
  var path: String {
    "/v1/completions"
  }

  var params: [String: Any] {
    switch self {
    case let .fetchCompletions(prompt):
      return [
        "model": "gpt-3.5-turbo",
        "messages": [
          [
            "role": "user",
            "content": prompt
          ]
        ],
        "temperature": 0.7
      ]
    }
  }

  var requestType: RequestType {
    .POST
  }
}
