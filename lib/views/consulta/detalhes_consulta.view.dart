import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:clinica_medica/components/bottom_nav_bar.dart';

class DetalhesConsultaView extends StatefulWidget {
  final int idMedico;
  final String data;
  final String hora;

  const DetalhesConsultaView(
      {Key? key,
      required this.idMedico,
      required this.data,
      required this.hora})
      : super(key: key);

  @override
  _DetalhesConsultaViewState createState() => _DetalhesConsultaViewState();
}

class _DetalhesConsultaViewState extends State<DetalhesConsultaView> {
  late Map<String, dynamic> consultaDetalhes;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetalhesConsulta();
  }

  Future<void> _fetchDetalhesConsulta() async {
    var idPessoa = 3;
    final response = await http.get(Uri.parse(
        'http://200.19.1.19/20221GR.ADS0013/clinica_medica/Controller/CrudDetalhesConsulta.php?Operacao=CON&id_pessoa=$idPessoa&id_medico=${widget.idMedico}&dt_consulta=${widget.data}&hr_inicio=${widget.hora}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        consultaDetalhes = data;
        isLoading = false;
      });
    } else {
      throw Exception('Serviço indisponível');
    }
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle titulo = TextStyle(fontSize: 20);
    const TextStyle subTitulo =
        TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    const TextStyle info = TextStyle(fontSize: 16);
    const Color corCinzaClaro = Color.fromARGB(255, 142, 142, 142);

    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: const Center(
          child: CircularProgressIndicator(),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: 0,
          onTap: (index) {
            // Lógica de navegação baseada no índice
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            const Text(
              'Detalhes da consulta',
              style: titulo,
            ),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${consultaDetalhes['nm_medico']} - ${consultaDetalhes['nu_crm'].trim()}',
                          style: subTitulo,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Consulta em ${consultaDetalhes['nm_especialidade']}',
                          style: info,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${consultaDetalhes['nu_tempo_consulta']} minutos',
                          style: info.copyWith(color: corCinzaClaro),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Unidade',
                          style: subTitulo,
                        ),
                        Text(
                          '${consultaDetalhes['nm_unidade']}',
                          style: info,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${consultaDetalhes['dt_consulta']}, ${consultaDetalhes['hr_inicio']}',
                          style: info,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Lógica de navegação baseada no índice
        },
      ),
    );
  }
}
