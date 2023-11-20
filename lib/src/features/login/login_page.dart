import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:prova_flutter/src/common/extensions/scaffold_extension.dart';
import 'package:prova_flutter/src/common/mixins/loading_mixin.dart';
import 'package:prova_flutter/src/common/mixins/stateful_mixin.dart';

import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with StatefulMixin, LoadingMixin {
  final LoginController controller = GetIt.instance.get();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  void onEnterClick() async {
    FocusScope.of(context).unfocus();

    if (formKey.currentState?.validate() ?? false) {
      showLoading();

      await controller.login(
        username.text,
        password.text,
        onSuccess: () async {
          removeLoading();

          showSuccessSnackbar('Seja bem vindo!');

          return context.goNamed('home');
        },
        onException: (exception) {
          removeLoading();

          return showErrorSnackbar(exception);
        },
      );
    }
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                'Usuário',
                style: textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 4.0),
              Material(
                type: MaterialType.transparency,
                elevation: 2.0,
                child: TextFormField(
                  controller: username,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo não pode ficar em branco!';
                    }

                    if (value.length > 20) {
                      return 'Este campo deve ter no maximo 20 caracteres!';
                    }

                    return null;
                  },
                  textAlignVertical: TextAlignVertical.center,
                  onFieldSubmitted: (_) => onEnterClick(),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(
                      Icons.person_rounded,
                      color: Color(0xFF212834),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Senha',
                style: textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 4.0),
              Material(
                type: MaterialType.transparency,
                elevation: 2.0,
                child: TextFormField(
                  controller: password,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo não pode ficar em branco!';
                    }

                    if (value.length < 2) {
                      return 'Este campo deve ter pelo menos 2 caracteres!';
                    }

                    if (value.length > 20) {
                      return 'Este campo deve ter no maximo 20 caracteres!';
                    }

                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  ],
                  textAlignVertical: TextAlignVertical.center,
                  onFieldSubmitted: (_) => onEnterClick(),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(
                      Icons.lock_rounded,
                      color: Color(0xFF212834),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: onEnterClick,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFF44bd6e),
                    ),
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(196.0, 48.0),
                    ),
                  ),
                  child: const Text('Entrar'),
                ),
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: controller.lauchPrivacyPolicy,
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all<Color>(
                      Colors.transparent,
                    ),
                  ),
                  child: Text(
                    'Politica de Privacidade',
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    ).withGradientBackground(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF1c4e64),
        const Color(0xFF2d958e),
      ],
    );
  }
}
