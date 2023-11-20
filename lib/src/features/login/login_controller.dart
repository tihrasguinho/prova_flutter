import 'package:prova_flutter/src/common/exceptions/app_exception.dart';
import 'package:prova_flutter/src/common/repositories/database_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginController {
  final DatabaseRepository repository;
  final SharedPreferences prefs;

  LoginController(this.repository, this.prefs);

  Future<void> login(
    String username,
    String password, {
    required void Function() onSuccess,
    required void Function(String exception) onException,
  }) async {
    try {
      final user = await repository.login(username, password);

      await prefs.setString('user', user.toJson());

      return onSuccess();
    } on AppException catch (e) {
      return onException(e.message);
    } on Exception {
      return onException('Ocorreu um erro inesperado, tente novamente mais tarde!');
    }
  }

  void lauchPrivacyPolicy() async {
    await launchUrl(Uri.parse('https://www.google.com.br'));
  }
}
