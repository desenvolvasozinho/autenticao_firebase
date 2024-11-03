import 'package:autenticacao_firebase/app/pages/auth/create_account_page.dart';
import 'package:autenticacao_firebase/app/pages/auth/login_page.dart';
import 'package:autenticacao_firebase/app/pages/home/home_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic>? generateRoutes(RouteSettings settings) {
    // BuildContext? ctx;
    if (settings.name == '/') {
      return MaterialPageRoute(builder: (_) => const LoginPage());
    } else if (settings.name == '/home-page') {
      return MaterialPageRoute(builder: (_) => const HomePage());
    } else if (settings.name == '/create-account-page') {
      return MaterialPageRoute(builder: (_) => const CreateAccountPage());
    } else {
      route_404();
    }
    return null;
  }

  static Route<dynamic> route_404() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Não encontrado 404'),
          ),
          body: const Center(
            child: Text('Não encontrado 404'),
          ),
        );
      },
    );
  }
}
