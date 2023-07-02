extension Task where Success == Never, Failure == Never {
  /// Suspends the current task for the specified time interval.
  ///
  /// - Parameter seconds: The duration as second to sleep for.
  ///
  /// Use this method to pause the execution of the current task for a given duration.
  /// The duration is specified in seconds, and it can be a fractional value.
  ///
  /// Example usage:
  /// ```
  /// print("Before sleep")
  /// try await Task.sleep(for: 1.5)
  /// print("After sleep")
  /// ```
  ///
  /// In the example above, the task pauses for 1.5 seconds before continuing execution.
  ///
  /// - Note: This method is a convenience wrapper around `Task.sleep(_:)`.
  static func sleep(for seconds: Double) async throws {
    let duration = UInt64(seconds * 1_000_000_000)
    try await Task.sleep(nanoseconds: duration)
  }
}
