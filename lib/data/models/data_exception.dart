/// The only error type providers let escape.
///
/// Controllers catch this instead of backend-specific exceptions, so they
/// keep working if the data source changes. [message] is safe to show; when
/// [messageKey] is set it is a translation key and takes precedence.
class DataException implements Exception {
  const DataException(this.message, {this.messageKey, this.cause});

  final String message;
  final String? messageKey;
  final Object? cause;

  @override
  String toString() => 'DataException($message${cause == null ? '' : ', cause: $cause'})';
}
