import 'package:clinica_medica/views/home/home.view.dart';
import 'package:clinica_medica/views/agenda/agenda.view.dart';
import 'package:flutter/material.dart';
import 'package:clinica_medica/views/themes/light.theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? idPessoa = prefs.getInt('id_pessoa');

  runApp(Root(initialRoute: idPessoa == null ? 'home' : 'agenda'));
}

class Root extends StatelessWidget {
  final String initialRoute;

  const Root({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clinica Médica',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: lightTheme,
      initialRoute: initialRoute,
      routes: {
        'home': (context) => const HomeView(),
        'agenda': (context) => const AgendaView()
      },
    );
  }
}
