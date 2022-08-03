import '../models/user.dart';

abstract class UserRepository {
Future<List<User>> getAllUsers();
  Future<User> getUserById(id);
  Future<User> createUser(User user);
  Future<void> deleteUser(id);
  Future<User> updateUser(User user);
}