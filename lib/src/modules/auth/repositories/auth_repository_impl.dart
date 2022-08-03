import '../datasources/auth_datasource.dart';

import '../errors/auth_errors.dart';
import '../../../core/services/bcrypt/bcrypt_service.dart';
import '../../../core/services/jwt/jwt_service.dart';
import '../../../core/services/request_extractor/request_extractor.dart';
import '../models/tokenization.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final BcryptService bcrypt;
  final JwtService jwt;
  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource, this.bcrypt, this.jwt);

  @override
  Future<Tokenization> login(LoginCredential credential) async {
    final userMap = await datasource.getIdAndRoleByEmail(credential.email);

    if (userMap.isEmpty) {
      throw AuthException(403, 'Email ou senha invalida');
    }

    if (!bcrypt.checkHash(credential.password, userMap['password'])) {
      throw AuthException(403, 'Email ou senha invalida');
    }

    final payload = userMap..remove('password');

    return _generateToken(payload);
  }

  @override
  Future<Tokenization> refreshToken(String token) async {
    final payload = jwt.getPayload(token);
    final role = await datasource.getRoleById(payload['id']);
    return _generateToken({
      'id': payload['id'],
      ' role': role,
    });
  }

  Tokenization _generateToken(Map payload) {
    payload['exp'] = _determineExpiration(Duration(minutes: 10));

    final accessToken = jwt.generateToken(payload, 'accessToken');

    payload['exp'] = _determineExpiration(Duration(days: 3));
    final refreshToken = jwt.generateToken(payload, 'refreshToken');
    return Tokenization(accessToken: accessToken, refreshToken: refreshToken);
  }

  int _determineExpiration(Duration duration) {
    final expiresDate = DateTime.now().add(duration);
    final expiresIn = Duration(milliseconds: expiresDate.millisecondsSinceEpoch);
    return expiresIn.inSeconds;
  }

  @override
  Future<void> updatePassword(String token, String password, String newPassword) async {
    final payload = jwt.getPayload(token);
    final hash = await datasource.getPasswordById(payload['id']);

    if (!bcrypt.checkHash(password, hash)) {
      throw AuthException(403, 'senha invalida');
    }

    newPassword = bcrypt.generateHash(newPassword);

    await datasource.updatePasswordById(payload['id'], newPassword);
  }
}
