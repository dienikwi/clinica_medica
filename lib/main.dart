import 'package:clinica_medica/views/cadastro/cadastro.view.dart';
import 'package:flutter/material.dart';
import 'package:clinica_medica/views/themes/light.theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const Root());
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clinica Médica',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: lightTheme,
      home: const CadastroView(),
    );
  }
}
