import 'dart:convert';

class UserErrors implements Exception {
  final String message;
  final StackTrace? stackTrace;
  final int statusCode;
  UserErrors(this.statusCode, this.message, [this.stackTrace]);

  String toJson() {
    return jsonEncode({'error': message});
  }
  

  @override
  String toString() => 'UserErrors(message: $message, stackTrace: $stackTrace, statusCode: $statusCode)';
}
