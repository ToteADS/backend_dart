import '../../../core/services/request_extractor/request_extractor.dart';
import '../models/tokenization.dart';

abstract class AuthRepository {
  Future<Tokenization> login(LoginCredential credential);
  Future<Tokenization> refreshToken(String token);
  Future<void> updatePassword(String token, String password, String newPassword);
}
