import 'package:flutter/material.dart';
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


  // Todos los usuarios registrados en el sistema, cargados desde la API
  List<User> allUsers = [];

  // Para controlar la selección en el dropdown de añadir usuarios
  Set<User> selectedUsersToAdd = {};

  bool isLoadingUsers = false;
  bool isSavingChanges = false;

  final TriAccountService apiService = TriAccountService();
  late Group _group;

  @override
  void initState() {
    super.initState();
    _group = widget.group;
    _loadAllUsers();
  }

  Future<void> _removeUser(String username) async  {
    await _group.removeUser(username);
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
        final List<User> usersNotInGroup = allUsers.where((u) => !_group.users.any((gu) => gu.id == u.id)).toList();

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
                  onPressed: selectedUsersToAdd.isEmpty? null : () async {
                    // Añadir usuarios seleccionados al grupo con amount 0
                    for (var user in selectedUsersToAdd) {
                      await _group.inviteUser(user.email);
                    }
                    selectedUsersToAdd.clear();
                    setState(() {});
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
      // Aquí se haría un botón de refresh para obtener cambios de la bd que
      // puede que no hubiera, en teoría no es necesario guardar nada
      // porque se va guardando sobre la marcha

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
          title: Text('${_group.groupName} Details'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                // Lógica para recargar los datos
              },
            ),
          ],
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Gastos'),
              Tab(text: 'Saldos'),
              Tab(text: 'Usuarios'),
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
                  "Gastos Totales: ${_group.totalExpense.toStringAsFixed(2)} €",
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
                          itemCount: _group.expenses.length,
                          itemBuilder: (context, index) {
                            final entry = _group.expenses[index];
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
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "${entry.cost.toStringAsFixed(2)} €",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('Eliminar gasto'),
                                                content: const Text('¿Estás seguro de que deseas eliminar este gasto?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Cancelar'),
                                                    ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await _group.removeExpense(entry);
                                                      setState(() {});
                                                      Navigator.pop(context); // Por ahora, solo cerramos el diálogo
                                                    },
                                                    child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    onTap: () async {
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
                              onPressed: () async {
                                final addEx = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddExpensePage(
                                      group: _group,
                                      groupUsers: _group.balances.keys.toList(),
                                    ),
                                  ),
                                );
                                try {
                                  await addEx();
                                  setState(() {});
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString().replaceFirst('ERROR: ', '')),
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                }
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
                      itemCount: _group.balances.keys.length,
                      itemBuilder: (context, index) {
                        final person = _group.balances.keys.elementAt(index);
                        final double amount = _group.balances[person] ?? 0.0;

                        final bool isPositive = amount > 0;
                        final bool isNegative = amount < 0;

                        // Color según el valor del saldo
                        final Color balanceColor = isPositive
                            ? Colors.green
                            : isNegative
                            ? Colors.red
                            : Colors.grey;

                        // Refunds del usuario si existen
                        final refundsMap = _group.refunds[person] ?? {};
                        bool showRefunds = false;

                        return StatefulBuilder(
                          builder: (context, setStateRefunds) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  color: Colors.grey[900],
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  elevation: 3,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    title: Text(
                                      person,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                    ),
                                    trailing: Text(
                                      "${amount >= 0 ? '+' : '-'}${amount.abs().toStringAsFixed(2)} €",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: balanceColor,
                                      ),
                                    ),
                                  ),
                                ),

                                // Botón para mostrar/ocultar devoluciones
                                if (refundsMap.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: TextButton.icon(
                                      icon: Icon(showRefunds ? Icons.expand_less : Icons.expand_more),
                                      label: Text(showRefunds ? 'Ocultar devoluciones' : 'Mostrar devoluciones'),
                                      onPressed: () {
                                        setStateRefunds(() {
                                          showRefunds = !showRefunds;
                                        });
                                      },
                                    ),
                                  ),

                                // Detalle de devoluciones
                                if (showRefunds && refundsMap.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 32.0, bottom: 12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: refundsMap.entries.map((entry) {
                                        return Text(
                                          '→ Debe a ${entry.key}: ${entry.value.toStringAsFixed(2)} €',
                                          style: const TextStyle(fontSize: 14, color: Colors.white70),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                              ],
                            );
                          },
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
                            itemCount: _group.balances.keys.length,
                            itemBuilder: (context, index) {
                              final user = _group.balances.keys.elementAt(index);
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
                                      bool canRemove = _group.balances[user] == 0;
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
                                      await _removeUser(user);
                                      setState(() {});
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
