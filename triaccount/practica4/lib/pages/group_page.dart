import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/group.dart';
import '../models/user.dart';
import '../services/triaccount_api_service.dart';
import 'expense_detail_page.dart';
import 'add_expense_page.dart';

class GroupPage extends StatefulWidget {
  final Group group;

 const GroupPage({super.key, required this.group});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> with SingleTickerProviderStateMixin {


  // Gasto dummy para comprobar si un usuario puede eliminarse
  final List<Map<String, dynamic>> dummyExpenses = [
    {"title": "Aceite", "buyer": "Imma", "amount": 5.5, "date": DateTime(2025, 2, 17)},
    {"title": "Arroz", "buyer": "Antonio", "amount": 2.1, "date": DateTime(2025, 2, 17)},
    {"title": "Fideos", "buyer": "Izaro", "amount": 3.0, "date": DateTime(2025, 2, 16)},
    {"title": "Tomate", "buyer": "Fernando", "amount": 1.5, "date": DateTime(2025, 2, 16)},
    {"title": "Bolígrafos", "buyer": "Andres", "amount": 4.2, "date": DateTime(2025, 5, 24)},
  ];

  // Todos los usuarios registrados en el sistema, cargados desde la API
  List<User> allUsers = [];

  // Para controlar la selección en el dropdown de añadir usuarios
  Set<User> selectedUsersToAdd = {};

  bool isLoadingUsers = false;
  bool isSavingChanges = false;

  final TriAccountService apiService = TriAccountService();

  Map<String, List<Map<String, dynamic>>> get expensesGroupedByDate {
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var expense in dummyExpenses) {
      DateTime date = expense["date"];
      String formattedDate = DateFormat("d 'de' MMMM 'de' y", 'es_ES').format(date);
      grouped.putIfAbsent(formattedDate, () => []).add(expense);
    }

    return Map.fromEntries(
      grouped.entries.toList()
        ..sort((a, b) {
          DateTime dateA = dummyExpenses.firstWhere((e) =>
          DateFormat("d 'de' MMMM 'de' y", 'es_ES').format(e["date"]) == a.key)["date"];
          DateTime dateB = dummyExpenses.firstWhere((e) =>
          DateFormat("d 'de' MMMM 'de' y", 'es_ES').format(e["date"]) == b.key)["date"];
          return dateB.compareTo(dateA);
        }),
    );
  }

  Future<bool> _canRemoveUser(String name) async {
    // Simula que no puede eliminar si es comprador de algún gasto
    return widget.group.balances[name] != 0;
  }

  @override
  void initState() {
    super.initState();
    _loadAllUsers();
  }

  Future<void> _loadAllUsers() async {
    setState(() {
      isLoadingUsers = true;
    });
    try {
      final users = await apiService.fetchUsers();
      setState(() {
        allUsers = users;
      });
    } catch (e) {
      debugPrint("Error cargando usuarios: $e");
    } finally {
      setState(() {
        isLoadingUsers = false;
      });
    }
  }


  void _openAddUsersDropdown() {
    showDialog(
      context: context,
      builder: (context) {
        // Usuarios que no están aún en el grupo
        final List<User> usersNotInGroup = allUsers.where((u) => !widget.group.users.any((gu) => gu.username == u.username)).toList();

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Añadir usuarios'),
              content: isLoadingUsers
                  ? SizedBox(
                height: 80,
                child: Center(child: CircularProgressIndicator()),
              )
                  : SizedBox(
                width: double.maxFinite,
                child: usersNotInGroup.isEmpty
                    ? const Text('No hay usuarios para añadir')
                    : ListView(
                  shrinkWrap: true,
                  children: usersNotInGroup.map((user) {
                    final isSelected = selectedUsersToAdd.contains(user);
                    return CheckboxListTile(
                      title: Text(user.username!),
                      value: isSelected,
                      onChanged: (checked) {
                        setStateDialog(() {
                          if (checked == true) {
                            selectedUsersToAdd.add(user);
                          } else {
                            selectedUsersToAdd.remove(user);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    selectedUsersToAdd.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: selectedUsersToAdd.isEmpty
                      ? null
                      : () {
                    setState(() {
                      // Añadir usuarios seleccionados al grupo con amount 0
                      for (var user in selectedUsersToAdd) {
                        widget.group.inviteUser(user.email);
                      }
                      selectedUsersToAdd.clear();
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Añadir'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _saveChanges() async {
    setState(() {
      isSavingChanges = true;
    });

    try {
      // Aquí harías la llamada a la API para actualizar usuarios del grupo:
      // por ejemplo, enviar la lista actualizada de usuarios en groupUsers al backend.

      // Simulamos espera
      await Future.delayed(const Duration(seconds: 1));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cambios guardados correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error guardando cambios: $e')),
      );
    } finally {
      setState(() {
        isSavingChanges = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.group.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Gastos'),
              Tab(text: 'Saldos'),
              Tab(text: 'Configuración'),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.teal[800],
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  "Gastos Totales: ${widget.group.totalExpense.toStringAsFixed(2)} €",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // TAB 1 - GASTOS con botón centrado horizontalmente abajo
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Stack(
                      children: [
                        // Lista principal de gastos
                        ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80), // Espacio para el botón
                          itemCount: widget.group.expenses.length,
                          itemBuilder: (context, index) {
                            final entry = widget.group.expenses[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Card(
                                  color: Colors.grey[900],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                  elevation: 3,
                                  child: ListTile(
                                    contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    title: Text(
                                      entry.title,
                                      style: const TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text("Pagado por: ${entry.buyer.username}"),
                                    trailing: Text(
                                      "${entry.cost.toStringAsFixed(2)} €",
                                      style: const TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.w600),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ExpenseDetailPage(expense: entry),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        // Botón flotante abajo en pantalla
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: FloatingActionButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddExpensePage(
                                      users: widget.group.users,
                                      groupName: widget.group.groupName,
                                      groupUsers: widget.group.balances.keys.toList(),
                                    ),
                                  ),
                                );
                              },
                              backgroundColor: Colors.grey[900],
                              child: const Icon(Icons.add, size: 32),
                              shape: const CircleBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // TAB 2 - SALDOS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                    child: ListView.builder(
                      itemCount: widget.group.balances.keys.length,
                      itemBuilder: (context, index) {
                        final person = widget.group.balances.keys.elementAt(index);
                        final double? amount = widget.group.balances[person];
                        final bool isPositive = amount! >= 0;

                        return Card(
                          color: Colors.grey[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          child: ListTile(
                            contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            title: Text(
                              person,
                              style:
                              const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            trailing: Text(
                              "${isPositive ? '+' : '-'}${amount.abs().toStringAsFixed(2)} €",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isPositive ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // TAB 3 - CONFIGURACIÓN
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Miembros del grupo:",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.builder(
                            itemCount: widget.group.balances.keys.length,
                            itemBuilder: (context, index) {
                              final user = widget.group.balances.keys.elementAt(index);
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                color: Colors.grey[900],
                                child: ListTile(
                                  title: Text(user),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () async {
                                      bool canRemove = await _canRemoveUser(user);
                                      if (!canRemove) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('No se puede eliminar'),
                                            content: Text(
                                                '$user no puede eliminarse porque tiene gastos pendientes.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('Cerrar'),
                                              ),
                                            ],
                                          ),
                                        );
                                        return;
                                      }
                                      setState(() {
                                          widget.group.removeUser(user);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _openAddUsersDropdown,
                          icon: const Icon(Icons.person_add),
                          label: const Text('Añadir usuarios'),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isSavingChanges ? null : _saveChanges,
                            child: isSavingChanges
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                                : const Text('Guardar cambios'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
