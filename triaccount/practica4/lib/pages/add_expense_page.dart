import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/group.dart';
import '../models/user.dart';
import '../moneyDivisorModule/DivideStrategy.dart';
import '../moneyDivisorModule/DivideByParts.dart';
import '../moneyDivisorModule/DivideEqually.dart';
import '../moneyDivisorModule/DivideByAmount.dart';

// Página que permite al usuario añadir un nuevo gasto dentro de un grupo
class AddExpensePage extends StatefulWidget {
  // Grupo al que se añadirá el gasto.
  final Group group;
  // Lista de usuarios del grupo.
  final List<String> groupUsers;

  AddExpensePage({required this.group, required this.groupUsers});

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  String? selectedBuyer;
  DateTime selectedDate = DateTime.now();
  Map<String, bool> participantSelected = {}; // Diccionario que indica si cada usuario está participando en el gasto
  String divideStrategy = 'equally';
  Map<String, int> partsCount = {}; // Número de partes por usuario (para estrategia "por partes")
  Map<String, double> manualAmounts = {}; // Cantidades asignadas manualmente (estrategia by amount)
  Map<String, bool> manualEdited = {}; // Indica si el usuario modificó manualmente su cantidad. (los campos modificados no se actualizan)
  late DivideStrategy strategy;
  bool isRefund = false; // Marca si el gasto es un reembolso

  @override
  void initState() {
    super.initState();

    // Inicializa datos por usuario: todos están seleccionados y con valores por defecto
    for (var user in widget.groupUsers) {
      participantSelected[user] = true;
      partsCount[user] = 1;
      manualAmounts[user] = 0.0;
      manualEdited[user] = false;
    }
    selectedBuyer = widget.groupUsers.first; // El comprador por defecto es el primero
    strategy = DivideEqually();
  }

  // Abre el selector de fecha y actualiza la fecha elegida
  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  // Actualiza la estrategia seleccionada
  void _updateStrategy(String strategyName) {
    switch (strategyName) {
      case 'by parts':
        strategy = DivideByParts();
        break;
      case 'by amount':
      // Instanciado en _calculateDivision
        break;
      default:
        strategy = DivideEqually();
    }
  }

  // Calcula la división del gasto de entre los participantes segun la estrategia seleccionada
  Map<String, double> _calculateDivision() {
    final total = double.tryParse(amountController.text) ?? 0.0;
    // Construye el mapa de participación (usuarios activos y sus partes o 1)
    final participation = <String, int>{};
    for (var user in widget.groupUsers) {
      if (participantSelected[user]!) {
        participation[user] = divideStrategy == 'by parts' ? partsCount[user]! : 1;
      }
    }

    // Si la estrategia es por importe manual, se usa DivideByAmount con los valores editados
    if (divideStrategy == 'by amount') {
      final filteredManual = <String, double>{};
      for (var entry in manualEdited.entries) {
        if (entry.value && participantSelected[entry.key]!) {
          filteredManual[entry.key] = manualAmounts[entry.key]!;
        }
      }
      strategy = DivideByAmount(filteredManual);
    }

    return strategy.calculateDivision(participation, total);
  }

  // Construye la interfaz de la página
  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    _updateStrategy(divideStrategy);
    final divisions = _calculateDivision();

    return Scaffold(
      appBar: AppBar(title: const Text("Añadir Gasto")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Título", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Introduce un título"),
                validator: (value) => value!.isEmpty ? "Por favor introduce un título" : null,
              ),
              const SizedBox(height: 16),
              const Text("Importe (€)", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(labelText: "Importe"),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedBuyer,
                      decoration: const InputDecoration(labelText: "Pagado por"),
                      items: widget.groupUsers.map((user) => DropdownMenuItem(value: user, child: Text(user))).toList(),
                      onChanged: (value) => setState(() => selectedBuyer = value),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: "Fecha"),
                        child: Text(formattedDate),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text("Participantes", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Column(
                children: widget.groupUsers.map((user) {
                  double displayAmount = divisions[user] ?? 0.0;

                  return Row(
                    children: [
                      Checkbox(
                        value: participantSelected[user],
                        onChanged: (val) {
                          setState(() {
                            participantSelected[user] = val!;
                            if (!val && divideStrategy == 'by amount') {
                              manualAmounts[user] = 0.0;
                              manualEdited[user] = false;
                            }
                          });
                        },
                      ),
                      Expanded(child: Text(user)),
                      if (divideStrategy == 'by parts') ...[
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: participantSelected[user]! ? () {
                            setState(() {
                              partsCount[user] = (partsCount[user]! - 1).clamp(1, 100);
                            });
                          } : null,
                        ),
                        Text("${partsCount[user]}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: participantSelected[user]! ? () {
                            setState(() {
                              partsCount[user] = partsCount[user]! + 1;
                            });
                          } : null,
                        ),
                        Text(" ${displayAmount.toStringAsFixed(2)} €"),
                      ] else if (divideStrategy == 'by amount')
                        SizedBox(
                          width: 80,
                          child: TextFormField(
                            enabled: participantSelected[user],
                            controller: TextEditingController.fromValue(TextEditingValue(
                              text: manualEdited[user]! ? manualAmounts[user]!.toStringAsFixed(2) : displayAmount.toStringAsFixed(2),
                              selection: TextSelection.collapsed(offset: (manualEdited[user]! ? manualAmounts[user]!.toStringAsFixed(2) : displayAmount.toStringAsFixed(2)).length),
                            )),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                            decoration: const InputDecoration(),
                            onChanged: (val) {
                              final v = double.tryParse(val);
                              if (v != null) {
                                setState(() {
                                  manualAmounts[user] = v;
                                  manualEdited[user] = true;
                                });
                              }
                            },
                          ),
                        )
                      else
                        Text("${displayAmount.toStringAsFixed(2)} €"),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: divideStrategy,
                decoration: const InputDecoration(labelText: "Dividir"),
                items: const [
                  DropdownMenuItem(value: 'equally', child: Text("Por igual")),
                  DropdownMenuItem(value: 'by parts', child: Text("Por partes")),
                  DropdownMenuItem(value: 'by amount', child: Text("Importe manual")),
                ],
                onChanged: (value) => setState(() => divideStrategy = value!),
              ),
              const SizedBox(height: 16),

              CheckboxListTile(
                title: const Text("¿Es un reembolso?"),
                value: isRefund,
                onChanged: (val) {
                  setState(() {
                    isRefund = val!;
                  });
                },
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: () {
                  setState(() {}); // Fuerza el recálculo y actualización visual
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Actualizar información"),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.of(context).pop(() async {
                      await widget.group.addExpense(
                        titleController.text,
                        double.parse(amountController.text),
                        selectedDate,
                        selectedBuyer!,
                        _calculateDivision(),
                        isRefund,
                        null,
                      );
                    });
                  }
                },
                child: const Text("Añadir Gasto"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
