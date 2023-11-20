import 'package:flutter/material.dart';

import 'config.dart';
import 'src/main_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await config();

  runApp(const MainWidget());
}
