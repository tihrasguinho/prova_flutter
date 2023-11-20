import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:prova_flutter/src/common/extensions/scaffold_extension.dart';
import 'package:prova_flutter/src/common/mixins/loading_mixin.dart';
import 'package:prova_flutter/src/common/mixins/stateful_mixin.dart';

import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with StatefulMixin, LoadingMixin {
  final HomeController controller = GetIt.instance.get();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController input = TextEditingController();

  late final AppLifecycleListener appLifecycleListener;

  @override
  void initState() {
    super.initState();

    appLifecycleListener = AppLifecycleListener(
      onRestart: () async => await controller.sincronizeNotes(
        onException: showErrorSnackbar,
      ),
      onResume: () async => await controller.sincronizeNotes(
        onException: showErrorSnackbar,
      ),
    );

    scheduleMicrotask(() async {
      showLoading();

      await controller.getNotes(onSuccess: showSuccessSnackbar, onException: showErrorSnackbar);

      removeLoading();
    });
  }

  @override
  void dispose() {
    input.dispose();
    appLifecycleListener.dispose();
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
              SizedBox(height: MediaQuery.of(context).padding.top + 36.0),
              Expanded(
                child: Material(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Observer(
                    builder: (context) {
                      return ListView.separated(
                        separatorBuilder: (_, __) => const Divider(
                          indent: 16.0,
                          endIndent: 16.0,
                          thickness: 1.0,
                        ),
                        padding: EdgeInsets.zero,
                        itemCount: controller.store.notes.length,
                        itemBuilder: (context, index) {
                          final note = controller.store.notes[index];

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Text(
                                  note.text,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.titleMedium?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  final text = await showDialog<String>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      final GlobalKey<FormState> innerFormKey = GlobalKey<FormState>();
                                      final TextEditingController innerInput = TextEditingController(text: note.text);

                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                                        title: const Text('Editar nota!'),
                                        content: Form(
                                          key: innerFormKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                controller: innerInput,
                                                autofocus: true,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'Este campo não pode ficar em branco!';
                                                  }

                                                  return null;
                                                },
                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                onFieldSubmitted: (_) => context.pop(innerInput.text),
                                                decoration: const InputDecoration(
                                                  contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                                  ),
                                                  isDense: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => context.pop(),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              if (innerFormKey.currentState?.validate() ?? false) {
                                                return context.pop(innerInput.text);
                                              }
                                            },
                                            child: const Text('Salvar'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (text != null) {
                                    showLoading();

                                    await controller.updateNote(
                                      note.copyWith(text: text),
                                      onSuccess: (message) {
                                        removeLoading();

                                        return showSuccessSnackbar(message);
                                      },
                                      onException: (exception) {
                                        removeLoading();

                                        return showErrorSnackbar(exception);
                                      },
                                    );
                                  }
                                },
                                icon: const Icon(Icons.border_color_rounded),
                              ),
                              IconButton(
                                onPressed: () async {
                                  final delete = await showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6.0),
                                        ),
                                        title: const Text('Excluir nota!'),
                                        content: const Text('Esta ação não poderá ser desfeita.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: const Text('Excluir'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (delete ?? false) {
                                    showLoading();

                                    return await controller.removeNote(
                                      note,
                                      onSuccess: (message) {
                                        removeLoading();

                                        return showSuccessSnackbar(message);
                                      },
                                      onException: (exception) {
                                        removeLoading();

                                        return showErrorSnackbar(exception);
                                      },
                                    );
                                  }
                                },
                                icon: const Icon(Icons.cancel_rounded, color: Colors.red),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              TextFormField(
                controller: input,
                textAlign: TextAlign.center,
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo não pode ficar em branco!';
                  }

                  return null;
                },
                onFieldSubmitted: (value) async {
                  if (formKey.currentState?.validate() ?? false) {
                    showLoading();

                    await controller.addNote(
                      value,
                      onSuccess: (message) {
                        input.clear();
                        removeLoading();
                        return showSuccessSnackbar(message);
                      },
                      onException: (exception) {
                        removeLoading();
                        return showErrorSnackbar(exception);
                      },
                    );
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Digite seu texto',
                  hintStyle: textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                ),
              ),
              const SizedBox(height: 32.0),
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
