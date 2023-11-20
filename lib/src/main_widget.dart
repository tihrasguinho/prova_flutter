import 'package:flutter/material.dart';
import 'package:prova_flutter/router.dart';

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Prova Flutter',
      routerConfig: router,
      theme: ThemeData.light(useMaterial3: false),
      darkTheme: ThemeData.dark(useMaterial3: false),
      themeMode: ThemeMode.light,
    );
  }
}
