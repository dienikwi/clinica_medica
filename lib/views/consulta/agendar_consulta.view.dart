import 'package:flutter/material.dart';
import 'package:clinica_medica/components/bottom_nav_bar.dart';

class AgendarConsultaView extends StatefulWidget {
  const AgendarConsultaView({super.key});

  @override
  _AgendarConsultaViewState createState() => _AgendarConsultaViewState();
}

class _AgendarConsultaViewState extends State<AgendarConsultaView> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const TextStyle titulo = TextStyle(fontSize: 20);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 80),
              const Text(
                'Agendar consulta',
                style: titulo,
              ),
              const SizedBox(height: 40),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  labelText: 'Unidade',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Porto Alegre - Zona Norte',
                    child: Text('Porto Alegre - Zona Norte'),
                  ),
                  DropdownMenuItem(
                    value: 'Porto Alegre - Zona Sul',
                    child: Text('Porto Alegre - Zona Sul'),
                  ),
                ],
                onChanged: (String? newValue) {},
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  labelText: 'Especialidade',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Dermatologia',
                    child: Text('Dermatologia'),
                  ),
                  DropdownMenuItem(
                    value: 'Cardiologia',
                    child: Text('Cardiologia'),
                  ),
                ],
                onChanged: (String? newValue) {},
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  labelText: 'Médico especialista',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Carlos Ferreira de Castro',
                    child: Text('Carlos Ferreira de Castro'),
                  ),
                  DropdownMenuItem(
                    value: 'Luísa Martins Castilhos',
                    child: Text('Luísa Martins Castilhos'),
                  ),
                ],
                onChanged: (String? newValue) {},
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  labelText: 'Data',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: _selectedDate != null
                      ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                      : '',
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  labelText: 'Horário',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: _selectedTime != null
                      ? "${_selectedTime!.format(context)}"
                      : '',
                ),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime ?? TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _selectedTime = pickedTime;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Implementar lógica para agendar consulta
                    }
                  },
                  child: const Text('Agendar'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          // Lógica de navegação baseada no índice
        },
      ),
    );
  }
}
