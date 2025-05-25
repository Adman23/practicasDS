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
  final Map<String, bool> selectedUsers = {}; // clave: email

  bool _isLoading = true;

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
          selectedUsers[user.email!] = false; // usar email como identificador único
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
    }
  }

  void _handleSubmit() {
    final groupName = _groupNameController.text.trim();
    final selected = selectedUsers.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key) // emails seleccionados
        .toList();

    if (groupName.isEmpty || selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Introduce un nombre y selecciona al menos un participante.')),
      );
      return;
    }

    // TODO: Llamar a la API para crear el grupo usando TriAccountService
    // await TriAccountService().createGroup(currentUser.id, groupName, selected);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Grupo "$groupName" creado con ${selected.length} participantes.')),
    );
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
            ...users.map((user) {
              return CheckboxListTile(
                title: Text(user.username ?? 'Sin nombre'),
                subtitle: Text(user.email ?? 'Sin email', style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                value: selectedUsers[user.email],
                onChanged: (bool? value) {
                  setState(() {
                    selectedUsers[user.email!] = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.grey[900],
              );
            }).toList(),
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
            )
          ],
        ),
      ),
    );
  }
}
