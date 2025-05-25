import 'package:flutter/material.dart';
import '../services/triaccount_api_service.dart';
import '../models/user.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({super.key});

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final TextEditingController _groupNameController = TextEditingController();

  List<User> users = [];
  final Map<String, bool> selectedUsers = {};
  bool _isLoading = true;
  bool _showUserList = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final fetchedUsers = await TriAccountService().fetchUsers();
      setState(() {
        users = fetchedUsers;
        for (var user in users) {
          if (user.email != null) {
            selectedUsers[user.email!] = false;
          }
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar usuarios: $e')),
      );
      users = [
        User(id: 1, username: 'Dummy1', email: 'dummy1@example.com'),
        User(id: 2, username: 'Dummy2', email: 'dummy2@example.com'),
        User(id: 3, username: 'Dummy3', email: 'dummy3@example.com'),
      ];
    }
  }

  void _handleSubmit() {
    final groupName = _groupNameController.text.trim();
    final selected = selectedUsers.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (groupName.isEmpty || selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Introduce un nombre y selecciona al menos un participante.')),
      );
      return;
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Grupo "$groupName" creado con ${selected.length} participantes.')),
    );
  }

  String _selectedUsersSummary() {
    final selected = selectedUsers.entries.where((e) => e.value).map((e) => e.key).toList();
    if (selected.isEmpty) return 'Seleccionar participantes';
    return selected.length == 1 ? selected.first : '${selected.length} seleccionados';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear Grupo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Text(
              'Nombre del Grupo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(
                hintText: 'Ej. Viaje a Madrid',
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Selecciona Participantes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => setState(() => _showUserList = !_showUserList),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[900]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _selectedUsersSummary(),
                        style: const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(_showUserList ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            if (_showUserList)
              Column(
                children: users.map((user) {
                  final email = user.email ?? '';
                  return CheckboxListTile(
                    title: Text(user.username ?? 'Sin nombre'),
                    subtitle: Text(email),
                    value: selectedUsers[email] ?? false,
                    onChanged: (bool? value) {
                      setState(() {
                        selectedUsers[email] = value ?? false;
                      });
                    },
                  );
                }).toList(),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[900],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Crear Grupo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
