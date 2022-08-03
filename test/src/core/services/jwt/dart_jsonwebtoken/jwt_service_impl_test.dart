import 'package:backend/src/core/services/dot_env/dot_env_service.dart';
import 'package:backend/src/core/services/jwt/dart_jsonwebtoken/jwt_service_impl.dart';
import 'package:test/test.dart';

void main() {
  test('jwt create ...', () async {
    final dotEnvService = DotEnvService(mocks: {'JWT_KEY': 'gkjajsfhajskfhajfnajlansfa'});
    final jwt = JwtServiceImpl(dotEnvService);

    final expiresDate = DateTime.now().add(Duration(seconds: 30));
    final expiresInSec = Duration(milliseconds: expiresDate.microsecondsSinceEpoch).inSeconds;

    final token = jwt.generateToken({'id': 1, 'role': 'user', 'exp': expiresInSec}, 'accessToken');

    print(token);
  });
}
