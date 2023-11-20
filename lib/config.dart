import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:prova_flutter/src/common/repositories/database_remote_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/common/repositories/database_repository.dart';
import 'src/features/home/home_controller.dart';
import 'src/features/home/home_store.dart';
import 'src/features/login/login_controller.dart';

Future<void> config() async {
  final getIt = GetIt.instance;

  const baseURL = String.fromEnvironment('baseURL');

  final dio = Dio(BaseOptions(baseUrl: baseURL));

  final prefs = await SharedPreferences.getInstance();

  getIt.registerSingleton<Dio>(dio);

  getIt.registerSingleton<SharedPreferences>(prefs);

  getIt.registerFactory<DatabaseRepository>(() => DatabaseRemoteRepository(getIt()));

  getIt.registerSingleton<HomeStore>(HomeStore());

  getIt.registerFactory<LoginController>(() => LoginController(getIt(), getIt()));

  getIt.registerFactory<HomeController>(() => HomeController(getIt(), getIt(), getIt()));
}
