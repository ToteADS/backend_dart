import 'package:backend/src/modules/user/errors/user_errors.dart';
import 'package:backend/src/modules/user/models/user.dart';

import '../../../core/services/database/remote_database.dart';
import './user_datasource.dart';

class UserDatasourceImpl implements UserDatasource {
  final RemoteDatabase database;
  UserDatasourceImpl(
    this.database,
  );

  @override
  Future<Map<String, dynamic>> createUser(User user) async {
    if(user.name == null || user.password == null || user.email == null){
      throw UserErrors(400, 'Name, Password, Email são obrigatórios');
    }
    try {
      final query = 'INSERT INTO "User" (name, email, password) VALUES ( @name, @email, @password ) RETURNING id, email, role, name;';
      final result = await database.query(
        query,
        variables: user.createUsertoMap(),
      );
      final userResult = result.map((e) => e['User']).first ?? {};

      if (userResult.isEmpty) {
        return {};
      }

      return userResult;
    } on Exception catch (e, s) {
      throw UserErrors(500, e.toString(), s);
    }
  }

  @override
  Future<void> deleteUser(id) async {
    try {
      final query = 'DELETE FROM "User" WHERE id = @id;';
      await database.query(query, variables: {'id': id});
    } on Exception catch (e, s) {
      throw UserErrors(500, e.toString(), s);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final query = 'SELECT id, name, email, role FROM "User";';
    try {
      final result = await database.query(query);
      return result.map((e) => e['User'] as Map<String, dynamic>).toList();
    } on Exception catch (e, s) {
      throw UserErrors(500, e.toString(), s);
    }
  }

  @override
  Future<Map<String, dynamic>> getUserById(id) async {
    try {
      final query = 'SELECT id, name, email, role FROM "User" WHERE id = @id;';
      final result = await database.query(query, variables: {'id': id});
      final userResult = result.map((e) => e['User']).first ?? {};
      if (result.isEmpty) {
        return {};
      }
      return userResult;
    } on Exception catch (e, s) {
      throw UserErrors(500, e.toString(), s);
    }
  }

  @override
  Future<Map<String, dynamic>> updateUser(User user) async {
    try {
      final userParams = user.toMap();

      final columns = userParams.keys
          .where((key) => key != 'id' || key != 'password')
          .map(
            (key) => '$key=@$key',
          )
          .toList();

      final query = 'UPDATE "User" SET ${columns.join(',')} WHERE id=@id RETURNING id, email, role, name;';

      final result = await database.query(
        query,
        variables: userParams,
      );

      final userResult = result.map((e) => e['User']).first ?? {};

      if (userResult.isEmpty) {
        return {};
      }

      return userResult;
    } on Exception catch (e, s) {
      throw UserErrors(500, e.toString(), s);
    }
  }
}
