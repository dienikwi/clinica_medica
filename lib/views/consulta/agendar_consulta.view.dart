import 'package:clinica_medica/views/agenda/agenda.view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:clinica_medica/components/bottom_nav_bar.dart';

class AgendarConsultaView extends StatefulWidget {
  const AgendarConsultaView({super.key});

  @override
  _AgendarConsultaViewState createState() => _AgendarConsultaViewState();
}

class _AgendarConsultaViewState extends State<AgendarConsultaView> {
  DateTime? _selectedDate;
  String? _selectedHorario;
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _unidades = [];
  List<Map<String, dynamic>> _especialidades = [];
  List<Map<String, dynamic>> _medicos = [];
  List<String> _horariosDisponiveis = [];
  String? _selectedUnidade;
  String? _selectedEspecialidade;
  String? _selectedMedico;
  String? _selectedEspecialidadeId;
  bool _isHorarioVisible = false;
  bool _isAgendarVisible = false;

  @override
  void initState() {
    super.initState();
    _fetchUnidades();
  }

  Future<void> _fetchUnidades() async {
    final response = await http.get(
      Uri.parse(
        'http://200.19.1.19/20221GR.ADS0013/clinica_medica/Controller/CrudUnidades.php?Operacao=CON',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _unidades = data
            .map((unidade) => {
                  'id_unidade': unidade['id_unidade'].toString(),
                  'nm_unidade': unidade['nm_unidade'],
                })
            .toList();
      });
    }
  }

  Future<void> _fetchEspecialidades(String idUnidade) async {
    final response = await http.get(
      Uri.parse(
        'http://200.19.1.19/20221GR.ADS0013/clinica_medica/Controller/CrudUnidadeMedico.php?Operacao=CON&Id_Unidade=$idUnidade',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _especialidades = data
            .map((especialidade) => {
                  'nm_especialidade': especialidade['nm_especialidade'],
                  'id_especialidade':
                      especialidade['id_especialidade'].toString(),
                })
            .toList();
      });
    }
  }

  Future<void> _fetchMedicos(String idUnidade, String nmEspecialidade) async {
    final response = await http.get(
      Uri.parse(
        'http://200.19.1.19/20221GR.ADS0013/clinica_medica/Controller/CrudEspecialidadeMedico.php?Operacao=CON&Nm_Especialidade=$nmEspecialidade&Id_Unidade=$idUnidade',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _medicos = data
            .map((medico) => {
                  'nm_pessoa': medico['nm_pessoa'],
                  'nu_crm': medico['nu_crm'],
                  'id_medico': medico['id_medico'].toString(),
                })
            .toList();
      });
    }
  }

  Future<void> _fetchHorariosDisponiveis(String idMedico,
      String idEspecialidade, String idUnidade, String dtConsulta) async {
    final response = await http.get(
      Uri.parse(
        'http://200.19.1.19/20221GR.ADS0013/clinica_medica/Controller/CrudDisponibilidade.php?Id_Medico=$idMedico&Id_Especialidade=$idEspecialidade&Id_Unidade=$idUnidade&Dt_Consulta=$dtConsulta',
      ),
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);

      if (decodedResponse is List) {
        setState(() {
          _horariosDisponiveis = decodedResponse
              .map((horario) => horario['horario_disponivel'].toString())
              .toList();
          _isHorarioVisible = true;
        });
      } else if (decodedResponse is Map) {
        setState(() {
          _horariosDisponiveis = [
            decodedResponse['horario_disponivel'].toString()
          ];
          _isHorarioVisible = true;
        });
      }
    } else if (response.statusCode == 404) {
      setState(() {
        _horariosDisponiveis = [];
      });
    }
  }

  Future<void> _agendarConsulta() async {
    if (_selectedMedico != null &&
        _selectedEspecialidadeId != null &&
        _selectedUnidade != null &&
        _selectedDate != null &&
        _selectedHorario != null) {
      final dtConsulta =
          '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}';

      final uri = Uri.parse(
              'http://200.19.1.19/20221GR.ADS0013/clinica_medica/Controller/CrudAgendamento.php')
          .replace(queryParameters: {
        'id_usuario': '3',
        'id_unidade': _selectedUnidade.toString(),
        'id_especialidade': _selectedEspecialidadeId.toString(),
        'id_medico': _selectedMedico.toString(),
        'data_consulta': dtConsulta,
        'hora_inicio': _selectedHorario,
      });

      final response = await http.post(uri);

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AgendaView(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erro ao agendar a consulta. Tente novamente.')),
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
                items: _unidades
                    .map((unidade) => DropdownMenuItem<String>(
                          value: unidade['id_unidade'],
                          child: Text(unidade['nm_unidade']),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedUnidade = newValue;
                      _especialidades = [];
                      _medicos = [];
                      _selectedEspecialidade = null;
                      _selectedMedico = null;
                    });
                    _fetchEspecialidades(newValue);
                  }
                },
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
                items: _especialidades
                    .map((especialidade) => DropdownMenuItem<String>(
                          value: especialidade['nm_especialidade'],
                          child: Text(especialidade['nm_especialidade']),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  if (newValue != null && _selectedUnidade != null) {
                    setState(() {
                      _selectedEspecialidade = newValue;
                      _selectedEspecialidadeId = _especialidades.firstWhere(
                              (e) => e['nm_especialidade'] == newValue)[
                          'id_especialidade'];
                      _medicos = [];
                      _selectedMedico = null;
                    });
                    _fetchMedicos(_selectedUnidade!, newValue);
                  }
                },
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
                items: _medicos
                    .map((medico) => DropdownMenuItem<String>(
                          value: medico['id_medico'],
                          child: Text(
                              '${medico['nm_pessoa']} - ${medico['nu_crm']}'),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMedico = newValue;
                  });
                },
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
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
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
                      if (_selectedMedico != null &&
                          _selectedEspecialidadeId != null &&
                          _selectedUnidade != null &&
                          _selectedDate != null) {
                        final dtConsulta =
                            '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}';
                        _fetchHorariosDisponiveis(
                          _selectedMedico!,
                          _selectedEspecialidadeId!,
                          _selectedUnidade!,
                          dtConsulta,
                        );
                      }
                    },
                    child: const Text('Buscar horários disponíveis'),
                  )),
              const SizedBox(height: 20),
              if (_isHorarioVisible)
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    labelText: 'Horário disponível',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  items: _horariosDisponiveis
                      .map((horario) => DropdownMenuItem<String>(
                            value: horario,
                            child: Text(horario),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedHorario = newValue;
                      _isAgendarVisible = true;
                    });
                  },
                ),
              const SizedBox(height: 20),
              if (_isAgendarVisible)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      _agendarConsulta();
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
