extension Optional where Wrapped == String {
  var orEmpty: String {
    self ?? ""
  }

  var isTextContainsCharacter: Bool {
    !(self ?? "").trimmingCharacters(in: .whitespaces).isEmpty
  }
}
