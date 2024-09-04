import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:clinica_medica/components/bottom_nav_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:clinica_medica/views/perfil/editar_perfil.view.dart';

class PerfilView extends StatelessWidget {
  const PerfilView({super.key});

  Future<Map<String, dynamic>> fetchData() async {
    var idPessoa = 3;
    final response = await http.get(Uri.parse(
        'http://200.19.1.19/20221GR.ADS0013/clinica_medica/Controller/CrudPessoa.php?Operacao=CON&id_pessoa=$idPessoa'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Servico indisponivel');
    }
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle titulo = TextStyle(fontSize: 20);
    const TextStyle buttonTextStyle = TextStyle(fontSize: 18);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              const Text(
                'Perfil',
                style: titulo,
              ),
              const SizedBox(height: 40),
              FutureBuilder<Map<String, dynamic>>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Erro ao carregar dados.'));
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Dados pessoais',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        data['nm_pessoa'],
                                        style: buttonTextStyle,
                                      ),
                                      Text(
                                        data['nm_genero'],
                                        style: buttonTextStyle,
                                      ),
                                      Text(
                                        data['dt_nascimento'],
                                        style: buttonTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    FontAwesomeIcons.userPen,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const EditarPerfilView(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: Text('Nenhum dado disponível.'));
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          // Lógica de navegação baseada no índice
        },
      ),
    );
  }
}
