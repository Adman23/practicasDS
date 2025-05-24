import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddExpensePage extends StatefulWidget {
  final String groupName;
  final List<String> groupUsers;

  AddExpensePage({required this.groupName, required this.groupUsers});

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  String? selectedBuyer;
  DateTime selectedDate = DateTime.now();
  Map<String, bool> participantSelected = {};
  String divideStrategy = 'equally';
  Map<String, int> partsCount = {};
  Map<String, double> manualAmounts = {};
  Map<String, bool> manualEdited = {};

  @override
  void initState() {
    super.initState();
    for (var user in widget.groupUsers) {
      participantSelected[user] = true;
      partsCount[user] = 1;
      manualAmounts[user] = 0.0;
      manualEdited[user] = false;
    }
    selectedBuyer = widget.groupUsers.first;
  }

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

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    final selectedCount = participantSelected.entries.where((e) => e.value).length;
    final total = double.tryParse(amountController.text) ?? 0.0;
    final int totalPartsSelected = partsCount.entries
        .where((e) => participantSelected[e.key] == true)
        .fold<int>(0, (sum, e) => sum + e.value);

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
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            hintText: "Introduce un título",
                            border: InputBorder.none,
                          ),
                          validator: (value) => value!.isEmpty ? "Por favor introduce un título" : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 57,
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 3,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () {
                          // lógica para añadir imagen
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Importe", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    controller: amountController,
                    decoration: const InputDecoration(
                      labelText: "Importe (€)",
                      border: InputBorder.none,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Pagado por:", style: TextStyle(fontWeight: FontWeight.w600)),
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButtonFormField<String>(
                              value: selectedBuyer,
                              decoration: const InputDecoration(border: InputBorder.none),
                              onChanged: (value) => setState(() => selectedBuyer = value),
                              items: widget.groupUsers.map((user) {
                                return DropdownMenuItem(value: user, child: Text(user));
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Fecha:", style: TextStyle(fontWeight: FontWeight.w600)),
                        InkWell(
                          onTap: _pickDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(formattedDate),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text("Participantes:", style: TextStyle(fontWeight: FontWeight.w600)),
              Column(
                children: widget.groupUsers.map((user) {
                  double displayAmount = 0.0;

                  if (participantSelected[user] == true) {
                    if (divideStrategy == 'equally') {
                      // ELEGIMOS ESTRATEGIA PARA DIVIDIR IGUALMENTE
                      displayAmount = total / (selectedCount == 0 ? 1 : selectedCount);
                    } else if (divideStrategy == 'by parts') {
                      // ELEGIMOS ESTRATEGIA PARA DIVIDIR POR PARTES
                      displayAmount = total * (partsCount[user]! / (totalPartsSelected == 0 ? 1 : totalPartsSelected));
                    } else if (divideStrategy == 'by amount') {
                      final totalAssigned = manualAmounts.entries
                          .where((e) => participantSelected[e.key]! && manualEdited[e.key]!)
                          .fold<double>(0.0, (sum, e) => sum + e.value);

                      final uneditedUsers = participantSelected.entries
                          .where((e) => e.value && !manualEdited[e.key]!)
                          .map((e) => e.key)
                          .toList();

                      final remaining = (total - totalAssigned).clamp(0.0, total);
                      final share = uneditedUsers.isEmpty ? 0.0 : remaining / uneditedUsers.length;

                      if (!manualEdited[user]!) {
                        manualAmounts[user] = share;
                      }

                      displayAmount = manualAmounts[user] ?? 0.0;
                    }
                  } else {
                    displayAmount = 0.0;
                    if (divideStrategy == 'by amount') {
                      manualAmounts[user] = 0.0;
                      manualEdited[user] = false;
                    }
                  }

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
                      if (divideStrategy == 'equally')
                        Text("${displayAmount.toStringAsFixed(2)} €"),
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
                        Text(
                          displayAmount.toStringAsFixed(2) + " €",
                          style: const TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                      if (divideStrategy == 'by amount')
                        SizedBox(
                          width: 80,
                          child: Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: TextFormField(
                                enabled: participantSelected[user],
                                initialValue: displayAmount.toStringAsFixed(2),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
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
                            ),
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text("Dividir: "),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonFormField<String>(
                          value: divideStrategy,
                          decoration: const InputDecoration(border: InputBorder.none),
                          onChanged: (value) => setState(() {
                            divideStrategy = value!;
                            if (divideStrategy != 'by amount') {
                              manualEdited.updateAll((key, _) => false);
                            }
                          }),
                          items: const [
                            DropdownMenuItem(value: 'equally', child: Text("Por igual")),
                            DropdownMenuItem(value: 'by parts', child: Text("Por partes")),
                            DropdownMenuItem(value: 'by amount', child: Text("Importe manual")),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Guardar gasto
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
