import 'package:flutter/material.dart';
import 'package:clinica_medica/components/bottom_nav_bar.dart';
import 'package:clinica_medica/components/consulta_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:clinica_medica/views/consulta/agendar_consulta.view.dart';
import 'package:clinica_medica/views/consulta/detalhes_consulta.view.dart'; // Importar a nova tela

class AgendaView extends StatelessWidget {
  const AgendaView({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle titulo = TextStyle(fontSize: 20);
    const TextStyle buttonTextStyle = TextStyle(fontSize: 18);

    // Simulação de dados de consulta
    bool temConsultas = true;
    List<Map<String, String>> consultas = [
      {
        'especialidade': 'Cardiologia',
        'paciente': 'Luísa Martins Castilhos',
        'dataHora': '10/02/2025, 14:30',
      },
      {
        'especialidade': 'Dermatologia',
        'paciente': 'Carlos Ferreira de Castro',
        'dataHora': '23/03/2025, 13:30',
      },
    ];

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
                            builder: (context) => const DetalhesConsultaView(),
                          ),
                        );
                      },
                      child: ConsultaCard(
                        especialidade: consulta['especialidade']!,
                        paciente: consulta['paciente']!,
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
