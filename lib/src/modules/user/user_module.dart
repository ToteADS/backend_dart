
import 'datasources/user_datasource_impl.dart';

import 'datasources/user_datasource.dart';
import 'reposiories/user_repository.dart';
import 'reposiories/user_repository_impl.dart';
import 'resources/user_resource.dart';
import 'package:shelf_modular/shelf_modular.dart';

class UserModule extends Module{

  @override
  List<Bind<Object>> get binds => [
    Bind.singleton<UserDatasource>((i) => UserDatasourceImpl(i())),
    Bind.singleton<UserRepository>((i) => UserRepositoryImpl(i()))
  ];

  @override
  List<ModularRoute> get routes => [
    Route.resource(UserResource())
  ];
  
}