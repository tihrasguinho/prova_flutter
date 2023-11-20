import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/features/home/home_page.dart';
import 'src/features/login/login_page.dart';
import 'src/features/not_found/not_found_page.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
      redirect: (context, state) async {
        final prefs = GetIt.instance.get<SharedPreferences>();

        if (prefs.getString('user') == null) return '/login';

        return null;
      },
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
      redirect: (context, state) async {
        final prefs = GetIt.instance.get<SharedPreferences>();

        if (prefs.getString('user') != null) return '/';

        return null;
      },
    ),
  ],
  errorBuilder: (context, state) => const NotFoundPage(),
);
