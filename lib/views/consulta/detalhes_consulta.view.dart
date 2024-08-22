import 'package:flutter/material.dart';
import 'package:clinica_medica/components/bottom_nav_bar.dart';

class DetalhesConsultaView extends StatelessWidget {
  const DetalhesConsultaView({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle titulo = TextStyle(fontSize: 20);
    const TextStyle subTitulo =
        TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    const TextStyle info = TextStyle(fontSize: 16);
    const Color corCinzaClaro = Color.fromARGB(255, 142, 142, 142);

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
                    const Text(
                      'Carlos Ferreira de Castro - CRM/RS 123355',
                      style: subTitulo,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Consulta em Dermatologia',
                      style: info,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '30 minutos',
                      style: info.copyWith(color: corCinzaClaro),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Unidade',
                      style: subTitulo,
                    ),
                    const Text(
                      'Porto Alegre - Zona Norte',
                      style: info,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '23/03/2025, 13:30',
                      style: info,
                    ),
                  ],
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
