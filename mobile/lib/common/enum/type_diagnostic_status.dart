enum TypeDiagnosticStatus { unread, read, importance }

extension TypeDiagnosticStatusExtension on TypeDiagnosticStatus {
  String get value {
    switch (this) {
      case TypeDiagnosticStatus.read:
        return "read";
      case TypeDiagnosticStatus.unread:
        return "unread";
      case TypeDiagnosticStatus.importance:
        return "importance";
    }
  }
}
