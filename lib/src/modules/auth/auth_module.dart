
import 'datasources/auth_datasource.dart';
import 'datasources/auth_datasource_impl.dart';
import 'repositories/auth_repository.dart';
import 'repositories/auth_repository_impl.dart';
import 'resources/auth_resource.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AuthModule extends Module{

  @override
  List<Bind<Object>> get binds => [
    Bind.singleton<AuthDatasource>((i) => AuthDatasourceImpl(i())),
    Bind.singleton<AuthRepository>((i) => AuthRepositoryImpl(i(),i(),i()))
  ];
  
  @override
  List<ModularRoute> get routes => [
    Route.resource(AuthResource())
  ];
}