import 'package:flutter/material.dart';
import 'package:clinica_medica/components/bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditarPerfilView extends StatefulWidget {
  const EditarPerfilView({super.key});

  @override
  _EditarPerfilViewState createState() => _EditarPerfilViewState();
}

class _EditarPerfilViewState extends State<EditarPerfilView> {
  DateTime? _selectedDate;
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();

  void _salvarAlteracoes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? idPessoa = prefs.getInt('id_pessoa');

    if (idPessoa == null) return;

    Map<String, String> dadosParaAtualizar = {};

    if (_nomeController.text.isNotEmpty) {
      dadosParaAtualizar['nm_pessoa'] = _nomeController.text;
    }
    if (_generoController.text.isNotEmpty) {
      dadosParaAtualizar['nm_genero'] = _generoController.text;
    }
    if (_dataNascimentoController.text.isNotEmpty) {
      dadosParaAtualizar['dt_nascimento'] = _dataNascimentoController.text;
    }

    if (dadosParaAtualizar.isNotEmpty) {
      dadosParaAtualizar['Operacao'] = 'EDIT';
      dadosParaAtualizar['id_pessoa'] = idPessoa.toString();

      var response = await http.post(
        Uri.parse(
            'http://200.19.1.19/20221GR.ADS0013/clinica_medica/Controller/CrudPessoa.php'),
        body: dadosParaAtualizar,
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['sucesso'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil atualizado com sucesso!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao atualizar o perfil')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro no servidor')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle titulo = TextStyle(fontSize: 20);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 80),
              const Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Editar Perfil',
                      style: titulo,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  floatingLabelStyle: TextStyle(color: Colors.blue),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  labelText: 'Gênero',
                  prefixIcon: Icon(Icons.checklist_rtl_rounded),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  floatingLabelStyle: TextStyle(color: Colors.blue),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Feminino',
                    child: Text('Feminino'),
                  ),
                  DropdownMenuItem(
                    value: 'Masculino',
                    child: Text('Masculino'),
                  ),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _generoController.text = newValue ?? '';
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dataNascimentoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  labelText: 'Data de Nascimento',
                  prefixIcon: Icon(Icons.calendar_month),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  floatingLabelStyle: TextStyle(color: Colors.blue),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                      _dataNascimentoController.text =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
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
                  onPressed: _salvarAlteracoes,
                  child: const Text('Salvar'),
                ),
              ),
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
