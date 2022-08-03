import 'package:backend/src/modules/user/datasources/user_datasource.dart';
import 'package:backend/src/modules/user/models/user.dart';

import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDatasource datasource;
  UserRepositoryImpl(
    this.datasource,
  );

  @override
  Future<User> createUser(User user) async {
    final result = await datasource.createUser(user);
    return User.fromMap(result);
  }

  @override
  Future<void> deleteUser(id) async {
    await datasource.deleteUser(id);
  }

  @override
  Future<List<User>> getAllUsers() async {
    final result = await datasource.getAllUsers();
    final listUser = <User>[];
    for (var element in result) {
      listUser.add(User.fromMap(element));
    }
    return listUser;
  }

  @override
  Future<User> getUserById(id) async {
    final result = await datasource.getUserById(id);
    return User.fromMap(result);
  }

  @override
  Future<User> updateUser(User user) async {
    final result = await datasource.updateUser(user);
    return User.fromMap(result);
  }
}
