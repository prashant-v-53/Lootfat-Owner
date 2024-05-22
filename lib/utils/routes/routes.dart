import 'package:flutter/material.dart';

class Routes {

  static Route<dynamic>  generateRoute(RouteSettings settings) {

    switch(settings.name){
      // case RoutesName.splash:
      //   return MaterialPageRoute(builder: (BuildContext context) => const SplashView());

      // case RoutesName.home:
      //   return MaterialPageRoute(builder: (BuildContext context) => const HomeScreen());

      // case RoutesName.login:
      //   return MaterialPageRoute(builder: (BuildContext context) => const LoginView());
      // case RoutesName.signUp:
      //   return MaterialPageRoute(builder: (BuildContext context) => const SignUpView());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });

    }
  }
}