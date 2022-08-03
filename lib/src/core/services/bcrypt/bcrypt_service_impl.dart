import 'bcrypt_service.dart';
import 'package:bcrypt/bcrypt.dart';

class BcryptServiceImpl implements BcryptService {
  @override
  bool checkHash(String text, String hash) {
    return BCrypt.checkpw(text, hash);
  }

  @override
  String generateHash(String text) {
    return BCrypt.hashpw(text, BCrypt.gensalt());
  }
}
