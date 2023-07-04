extension Optional where Wrapped == String {
  var orEmpty: String {
    self ?? .empty
  }

  var isTextContainsCharacter: Bool {
    !(self ?? .empty).trimmingCharacters(in: .whitespaces).isEmpty
  }
}
