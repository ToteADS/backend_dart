import 'modules/auth/auth_module.dart';
import 'modules/user/user_module.dart';
import 'core/core_module.dart';
import 'modules/swagger/swagger_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
    CoreModule(),
  ];

  @override
  List<ModularRoute> get routes => [
        Route.get("/", (Request request) => Response.ok("inicial")),
        Route.get('/documentation/**', swaggerHandler),
        Route.module('/user', module: UserModule()),
        Route.module('/auth', module: AuthModule())
      ];
}
