import 'dart:async';
import 'dart:convert';
import 'package:backend/src/core/services/bcrypt/bcrypt_service.dart';
import 'package:backend/src/modules/auth/guard/auth_guard.dart';
import 'package:backend/src/modules/user/errors/user_errors.dart';
import 'package:backend/src/modules/user/models/user.dart';
import 'package:backend/src/modules/user/reposiories/user_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class UserResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get("", _getAllUser, middlewares: [AuthGuard()]),
        Route.get("/:id", _getUserByid, middlewares: [AuthGuard()]),
        Route.post("/", _createUser),
        Route.put("/", _updateUser, middlewares: [
          AuthGuard(roles: ['admin'])
        ]),
        Route.delete("/:id", _deleteUser, middlewares: [
          AuthGuard(roles: ['admin'])
        ]),
      ];

  FutureOr<Response> _getAllUser(Injector injector) async {
    try {
      final repository = injector.get<UserRepository>();
      final result = await repository.getAllUsers();
      final usersMap = result.map((e) => e.toMap()).toList();
      return Response.ok(jsonEncode(usersMap));
    } on UserErrors catch (e) {
      return Response.internalServerError(body: e.toJson());
    }
  }

  FutureOr<Response> _getUserByid(ModularArguments arguments, Injector injector) async {
    try {
      final id = arguments.params['id'];
      final repository = injector.get<UserRepository>();
      var result = await repository.getUserById(id);
      return Response.ok(result.toJson());
    } on UserErrors catch (e) {
      return Response.internalServerError(body: e.toJson());
    }
  }

  FutureOr<Response> _deleteUser(ModularArguments arguments, Injector injector) async {
    try {
      final id = arguments.params['id'];
      final repository = injector.get<UserRepository>();
      await repository.deleteUser(id);
      return Response.ok(jsonEncode({'message': 'deleted $id'}));
    } on UserErrors catch (e) {
      return Response.internalServerError(body: e.toJson());
    }
  }

  FutureOr<Response> _createUser(ModularArguments arguments, Injector injector) async {
    try {
      final bcrypt = injector.get<BcryptService>();
      var userParams = (arguments.data as Map).cast<String, dynamic>();
      userParams['password'] = bcrypt.generateHash(userParams['password']);
      final user = User.fromMap(userParams);
      final repository = injector.get<UserRepository>();
      final result = await repository.createUser(user);
      return Response.ok(result.toJson());
    } on UserErrors catch (e) {
      return Response.internalServerError(body: e.toJson());
    }
  }

  FutureOr<Response> _updateUser(ModularArguments arguments, Injector injector) async {
    try {
      final userParams = (arguments.data as Map).cast<String, dynamic>();
      final user = User.fromMap(userParams);
      final repository = injector.get<UserRepository>();
      final result = await repository.updateUser(user);
      return Response.ok(result.toJson());
    } on UserErrors catch (e) {
      return Response.internalServerError(body: e.toJson());
    }
  }
}
