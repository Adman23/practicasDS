import 'package:flutter/material.dart';
import '../models/group.dart';
import '../models/user.dart';
import 'group_page.dart';
import '../services/triaccount_api_service.dart';
import 'login_page.dart';
import 'add_group_page.dart';

class HomePage extends StatefulWidget {
  final User loggedUser;
  const HomePage({super.key, this.loggedUser})



  @override
  State<HomePage> createState() => _HomePageState(loggedUser: loggedUser);
}

class _HomePageState extends State<HomePage> {

  List<String> groups = ['Piso 2° Cuatri', 'Vacaciones Roma'];


  final User loggedUser;
  final TriAccountService apiService = TriAccountService();
  static List<Group> userGroups = [];

  _HomePageState({required this.loggedUser}){
    _obtainGroups();
  }
  // Inicializar los grupos, se lanza en el constructor
  void _obtainGroups() async {
    userGroups = await loggedUser.getGroups();
  }

  void _handleLogout(BuildContext context) async {
    try {
      await apiService.logout();
      userGroups.clear();
      // Volver a login y limpiar la navegación
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  void _navigateToAddGroup() async {
    final newGroupName = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const AddGroupPage()),
    );

    if (newGroupName != null && newGroupName.isNotEmpty) {
      setState(() {
        groups.add(newGroupName);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Grupo "$newGroupName" añadido')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TRI-ACCOUNT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => _handleLogout(context),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Mis Grupos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: userGroups.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      title: Text(
                        userGroups[index].groupName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[400]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GroupPage(groupName: userGroups[index].groupName),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddGroup,
        backgroundColor: Colors.grey[900],
        child: const Icon(Icons.add, size: 32),
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
