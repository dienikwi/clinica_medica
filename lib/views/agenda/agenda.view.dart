import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:clinica_medica/components/bottom_nav_bar.dart';
import 'package:clinica_medica/components/consulta_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:clinica_medica/views/consulta/agendar_consulta.view.dart';
import 'package:clinica_medica/views/consulta/detalhes_consulta.view.dart';

class AgendaView extends StatefulWidget {
  const AgendaView({super.key});

  @override
  _AgendaViewState createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  List<Map<String, dynamic>> consultas = [];
  bool temConsultas = true;

  @override
  void initState() {
    super.initState();
    _fetchConsultas();
  }

  Future<void> _fetchConsultas() async {
    var idPessoa = 3;
    final response = await http.get(Uri.parse(
        'http://200.19.1.19/20221GR.ADS0013/clinica_medica/Controller/CrudAgendamento.php?Operacao=CON&id_pessoa=$idPessoa'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body.toString());

      if (data == null) {
        setState(() {
          temConsultas = false;
        });
      } else {
        setState(() {
          consultas = List<Map<String, dynamic>>.from(data.map((consulta) => {
                'especialidade': consulta['nm_especialidade']?.toString(),
                'idMedico': consulta['id_medico'],
                'medico': consulta['nm_medico']?.toString(),
                'data': consulta['dt_consulta']?.toString(),
                'hora': consulta['hr_inicio']?.toString(),
                'dataHora':
                    '${consulta['dt_consulta']}, ${consulta['hr_inicio']}',
              }));
        });
      }
    } else {
      setState(() {
        temConsultas = false;
      });
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
                'Próximas consultas',
                style: titulo,
              ),
              const SizedBox(height: 40),
              if (!temConsultas) ...[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Agende a próxima consulta',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Cuide-se e agende uma consulta com os melhores especialistas.',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            Icon(
                              FontAwesomeIcons.heartPulse,
                              color: Colors.blue,
                              size: 40,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AgendarConsultaView(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.search),
                            label: const Text(
                              'Agendar consulta',
                              style: buttonTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                for (var consulta in consultas)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalhesConsultaView(
                              idMedico: consulta['idMedico']!,
                              data: consulta['data']!,
                              hora: consulta['hora']!,
                            ),
                          ),
                        );
                      },
                      child: ConsultaCard(
                        especialidade: consulta['especialidade']!,
                        medico: consulta['medico']!,
                        dataHora: consulta['dataHora']!,
                      ),
                    ),
                  ),
              ],
            ],
          ),
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
