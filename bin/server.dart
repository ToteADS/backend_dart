import 'dart:io';
import 'package:backend/backend.dart';
import 'package:shelf/shelf_io.dart';

// Configure routes.

void main(List<String> args) async {
  final handler = await startShelfModular();
  final port = int.parse(Platform.environment['PORT'] ?? '4466');
  final server = await serve(handler, "0.0.0.0", port);
  print('Server online -> ${server.address.address} : ${server.port}');
}
