import '../models/user.dart';

abstract class UserDatasource {
  Future<List<Map<String,dynamic>>> getAllUsers();
  Future<Map<String,dynamic>> getUserById(id);
  Future<Map<String,dynamic>> createUser(User user);
  Future<void> deleteUser(id);
  Future<Map<String,dynamic>> updateUser(User user);
}
