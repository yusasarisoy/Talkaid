extension Optional where Wrapped == Bool {
  var orFalse: Bool {
    self ?? false
  }
}
